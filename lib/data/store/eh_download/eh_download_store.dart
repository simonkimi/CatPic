import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/download.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:catpic/data/store/download/download_store.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/models/gen/eh_download.pb.dart';
import 'package:catpic/data/bridge/file_helper.dart' as fh;
import 'package:executor/executor.dart';
import 'package:get/get.dart';
import 'package:catpic/utils/utils.dart';
import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

part 'eh_download_store.g.dart';

class EhDownloadStore = EhDownloadStoreBase with _$EhDownloadStore;

abstract class EhDownloadStoreBase with Store {
  @observable
  var downloadingList = ObservableList<EhDownloadTask>();

  final imageDownloadExec = Executor(concurrency: 3);

  final pageParseExec = Executor(concurrency: 3);

  Future<void> startDownload(
    EhDownloadTableData database,
    WebsiteTableData entity,
  ) async {
    startTimeLine();
    final adapter = EHAdapter(entity);
    // 创建下载任务
    final task = EhDownloadTask(
      gid: database.gid,
      gtoken: database.gtoken,
      finishPage: <int>{}.obs,
      pageCount: database.pageTotal.obs,
      state: EhDownloadState.PARSE_PAGE.obs,
      progress: 0.0.obs,
    );
    printTimeLine('EhDownloadTask');

    if (downloadingList.contains(task)) return;
    downloadingList.add(task);
    printTimeLine('downloadingList.add');
    final databaseGallery = GalleryModel.fromBuffer(database.galleryPb);
    // 创建下载文件夹
    final basePath =
        'Gallery/${database.gid}-${databaseGallery.title.replaceAll('/', '_')}';
    await fh.createDir(basePath);
    // 读取/创建 下载配置文件
    final configBytes = await fh.readFile(basePath, '.catpic');
    late EhDownloadModel configModel;
    if (configBytes == null) {
      configModel = EhDownloadModel(model: databaseGallery, pageInfo: {});
      await fh.writeFile(basePath, '.catpic', configModel.writeToBuffer());
    } else {
      configModel = EhDownloadModel.fromBuffer(configBytes);
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
    final needParsePages = List.generate(database.pageTotal, (index) => index)
        .where((e) => !configModel.pageInfo.containsKey(e))
        .map((e) => (e / 40).floor())
        .toSet();
    print(needParsePages);
    // final futures = needParsePages.map((e) => pageParseExec.scheduleTask(() async {
    //           var retry = 3;
    //           while (retry-- > 0) {
    //             try {
    //               final gallery = await adapter.gallery(
    //                 gid: database.gid,
    //                 gtoken: database.gtoken,
    //                 page: e,
    //                 cancelToken: task.cancelToken,
    //               );
    //               for (final imgEntity
    //                   in gallery.previewImages.asMap().entries) {
    //                 final reg = RegExp('s/(.+?)/(.+)');
    //                 final match = reg.firstMatch(imgEntity.value.target)!;
    //                 final token = match[1]!;
    //                 configModel.pageInfo[e * 40 + imgEntity.key] = token;
    //               }
    //               return;
    //             } on DioError catch (e) {
    //               if (CancelToken.isCancel(e)) return;
    //             }
    //           }
    //         }));
    // await Future.wait(futures);

    // // 开始下载图片
    // task.state.value = EhDownloadState.WORKING;
    // final pictureFutures = List.generate(database.pageTotal, (index) => index)
    //     .where((e) => !task.finishPage.contains(e))
    //     .toSet()
    //     .map((e) => imageDownloadExec.scheduleTask(() async {
    //           var retry = 3;
    //           while (retry-- > 0) {
    //             try {
    //               final imageModel = await adapter.galleryImage(
    //                 gid: database.gid,
    //                 gtoken: configModel.pageInfo[e]!,
    //                 page: e + 1,
    //               );
    //               final data = await _download(
    //                 imageUrl: imageModel.imgUrl,
    //                 dio: adapter.dio,
    //                 cacheKey: imageModel.sha,
    //                 cancelToken: task.cancelToken,
    //                 task: task,
    //               );
    //
    //               await fh.writeFile(
    //                   basePath,
    //                   '${(e + 1).format(9)}.${imageModel.imgUrl.split('.').last}',
    //                   data);
    //
    //               return;
    //             } on StateError {
    //               return;
    //             } on DioError catch (e) {
    //               if (CancelToken.isCancel(e)) return;
    //             }
    //           }
    //         }));
    // await Future.wait(pictureFutures);
  }

  Future<bool> createDownloadTask(
    String gid,
    String token,
    int websiteId,
  ) async {
    final dao = DB().ehDownloadDao;
    final existModel = await dao.getByGid(gid, token);

    final websiteEntity = await DB().websiteDao.getById(websiteId);
    if (websiteEntity == null) {
      return false;
    }

    if (existModel != null) {
      BotToast.showText(text: I18n.g.download_exist);
      return false;
    }

    final adapter = EHAdapter(websiteEntity);
    final model = await adapter.gallery(gid: gid, gtoken: token, page: 0);

    final id = await dao.insert(EhDownloadTableCompanion.insert(
      gid: model.gid,
      gtoken: model.token,
      websiteId: websiteId,
      status: DownloadStatus.PENDING,
      pageTotal: model.imageCount,
      pageDownload: 0,
      galleryPb: model.writeToBuffer(),
    ));

    final database = await dao.get(id);
    // startDownload(database!, adapter.website);
    return true;
  }

  Future<Uint8List> _download({
    Dio? dio,
    required String imageUrl,
    CancelToken? cancelToken,
    String? cacheKey,
    required EhDownloadTask task,
  }) async {
    final speed = DownloadSpeed();
    task.speedList.add(speed);
    try {
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
        throw StateError(
            '$imageUrl is empty and cannot be loaded as an image.');
      }
      final bytes = Uint8List.fromList(rsp.data!);
      if (bytes.lengthInBytes == 0) {
        throw StateError(
            '$imageUrl is empty and cannot be loaded as an image.');
      }
      return bytes;
    } finally {
      task.speedList.remove(speed);
    }
  }
}

class EhDownloadState {
  static const int WAITING = 0;
  static const int PARSE_PAGE = 1;
  static const int WORKING = 2;
  static const int FINISH = 3;
  static const int ERROR = 4;
}

@immutable
class EhDownloadTask {
  EhDownloadTask({
    required this.state,
    required this.pageCount,
    required this.finishPage,
    required this.gid,
    required this.gtoken,
    required this.progress,
  });

  final Rx<int> state;
  final Rx<int> pageCount;
  final RxSet<int> finishPage;
  final Rx<double> progress;
  final CancelToken cancelToken = CancelToken();
  final String gid;
  final String gtoken;
  final List<DownloadSpeed> speedList = [];

  @override
  int get hashCode => gid.hashCode + gtoken.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! EhDownloadTask) return false;

    return other.gtoken == gtoken && other.gid == gid;
  }

  Stream<int> get speed => Stream.periodic(
      1.seconds,
      (data) => speedList.fold(
          0,
          (previousValue, element) =>
              previousValue += element.getTimeReceived()));
}

@immutable
class DownloadSpeed {
  final received = 0.wrap;
  final receivedRecord = 0.wrap;

  int getTimeReceived() {
    final r = received.value - receivedRecord.value;
    received.value = receivedRecord.value;
    return r;
  }
}
