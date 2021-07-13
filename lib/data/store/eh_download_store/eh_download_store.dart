import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/download.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/models/gen/eh_download.pb.dart' as pb;
import 'package:catpic/data/bridge/file_helper.dart' as fh;
import 'package:executor/executor.dart';
import 'package:get/get.dart';
import 'package:catpic/utils/utils.dart';
import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

part 'eh_download_store.g.dart';

class EhDownloadStore = EhDownloadStoreBase with _$EhDownloadStore;

abstract class EhDownloadStoreBase with Store {
  var downloadingList = ObservableList<EhDownloadTask>();

  final imageDownloadExec = Executor(concurrency: 3);

  final pageParseExec = Executor(concurrency: 3);

  Future<void> startDownload(
    PreViewItemModel model,
    WebsiteTableData entity,
  ) async {
    final adapter = EHAdapter(entity);
    // 创建下载任务
    final task = EhDownloadTask(
      gid: model.gid,
      gtoken: model.gtoken,
      finishPage: <int>{}.obs,
      pageCount: model.pages.obs,
      state: EhDownloadState.PARSE_PAGE.obs,
    );

    if (downloadingList.contains(task)) return;

    // 创建下载文件夹
    final basePath = 'gallery/${model.gid}-${model.gtoken}';
    await fh.createDir(basePath);

    // 读取/创建 下载配置文件
    final configBytes = await fh.readFile(basePath, '.catpic');
    late pb.EhDownloadModel configModel;
    if (configBytes == null) {
      configModel = pb.EhDownloadModel(model: model.toPb(), pageInfo: {});
      await fh.writeFile(basePath, '.catpic', configModel.writeToBuffer());
    } else {
      configModel = pb.EhDownloadModel.fromBuffer(configBytes);
    }

    // 读取下载进度
    final existImages = (await fh.walk(basePath))
        .where((e) =>
            e.startsWith('0') &&
            (e.endsWith('.jpg') || e.endsWith('.png')) &&
            e.split('.').first.isNum)
        .map((e) => e.toInt());
    task.finishPage.addAll(existImages);

    // 解析配置, 解析图片下载地址
    final futures = List.generate(model.pages, (index) => index)
        .where((e) => !configModel.pageInfo.containsKey(e))
        .map((e) => (e / 40).floor())
        .toSet()
        .map((e) => pageParseExec.scheduleTask(() async {
              var retry = 3;
              while (retry-- > 0) {
                try {
                  final gallery = await adapter.gallery(
                      gid: model.gid,
                      gtoken: model.gtoken,
                      page: e,
                      cancelToken: task.cancelToken);
                  for (final imgEntity
                      in gallery.previewImages.asMap().entries) {
                    final reg = RegExp('s/(.+?)/(.+)');
                    final match = reg.firstMatch(imgEntity.value.target)!;
                    final token = match[1]!;
                    configModel.pageInfo[e * 40 + imgEntity.key] = token;
                  }
                  return;
                } on DioError catch (e) {
                  if (CancelToken.isCancel(e)) return;
                }
              }
            }));
    await Future.wait(futures);

    // 开始下载图片
    task.state.value = EhDownloadState.WORKING;
    final pictureFutures = List.generate(model.pages, (index) => index)
        .where((e) => !task.finishPage.contains(e))
        .toSet()
        .map((e) => imageDownloadExec.scheduleTask(() async {
              var retry = 3;
              while (retry-- > 0) {
                try {
                  final imageModel = await adapter.galleryImage(
                    gid: model.gid,
                    gtoken: configModel.pageInfo[e]!,
                    page: e + 1,
                  );
                  final data = await _download(
                    imageUrl: imageModel.imgUrl,
                    dio: adapter.dio,
                    cacheKey: imageModel.sha,
                    cancelToken: task.cancelToken,
                  );

                  await fh.writeFile(
                      basePath,
                      '${(e + 1).format(9)}.${imageModel.imgUrl.split('.').last}',
                      data);

                  return;
                } on StateError {
                  return;
                } on DioError catch (e) {
                  if (CancelToken.isCancel(e)) return;
                }
              }
            }));
    await Future.wait(pictureFutures);
  }

  Future<void> createDownloadTask(
    PreViewItemModel model,
  ) async {
    await DB().ehDownloadDao.insert(EhDownloadTableCompanion.insert(
          websiteId: mainStore.websiteEntity!.id,
          status: DownloadStatus.PENDING,
          pageTotal: model.pages,
          pageDownload: 0,
          gid: model.gid,
          gtoken: model.gtoken,
          previewItemPb: model.toPb().writeToBuffer(),
        ));
    startDownload(model, mainStore.websiteEntity!);
  }

  Future<Uint8List> _download({
    Dio? dio,
    required String imageUrl,
    CancelToken? cancelToken,
    String? cacheKey,
  }) async {
    final rsp = await (dio ?? Dio()).get<List<int>>(
      imageUrl,
      cancelToken: cancelToken,
      options: settingStore.dioCacheOptions
          .copyWith(
            policy: CachePolicy.request,
            keyBuilder: (req) =>
                cacheKey ?? const Uuid().v5(Uuid.NAMESPACE_URL, imageUrl),
          )
          .toOptions()
          .copyWith(responseType: ResponseType.bytes),
    );
    if (rsp.data == null) {
      throw StateError('$imageUrl is empty and cannot be loaded as an image.');
    }
    final bytes = Uint8List.fromList(rsp.data!);
    if (bytes.lengthInBytes == 0) {
      throw StateError('$imageUrl is empty and cannot be loaded as an image.');
    }
    return bytes;
  }
}

enum EhDownloadState {
  WAITING,
  PARSE_PAGE,
  WORKING,
  FINISH,
  ERROR,
}

@immutable
class EhDownloadTask {
  EhDownloadTask({
    required this.state,
    required this.pageCount,
    required this.finishPage,
    required this.gid,
    required this.gtoken,
  });

  final Rx<EhDownloadState> state;
  final Rx<int> pageCount;
  final RxSet<int> finishPage;
  final CancelToken cancelToken = CancelToken();
  final String gid;
  final String gtoken;

  @override
  int get hashCode => gid.hashCode + gtoken.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! EhDownloadTask) return false;

    return other.gtoken == gtoken && other.gid == gid;
  }
}
