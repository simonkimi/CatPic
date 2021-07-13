import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/download.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/bridge/android_bridge.dart' as bridge;
import 'package:catpic/utils/utils.dart';
import 'package:get/get.dart';
import 'package:catpic/data/bridge/file_helper.dart';

part 'download_store.g.dart';

class DownloadStore = DownloadStoreBase with _$DownloadStore;

class TaskExisted implements Exception {}

class DownloadPermissionDenied implements Exception {}

class WebsiteNotExisted implements Exception {}

class DownLoadTask {
  DownLoadTask(this.database);

  final DownloadTableData database;
  var progress = 0.0.obs;
  final cancelToken = CancelToken();

  @override
  String toString() {
    return '${database.fileName} $progress';
  }
}

abstract class DownloadStoreBase with Store {
  @observable
  var downloadingList = ObservableList<DownLoadTask>();

  final dao = DB().downloadDao;

  @action
  Future<void> createDownloadTask(BooruPost booruPost) async {
    if (Platform.isAndroid && await bridge.getSafUri() == null) {
      throw DownloadPermissionDenied();
    }

    if (Platform.isWindows) {
      throw DownloadPermissionDenied();
    }

    final taskList = await dao.getAll();
    if (taskList
            .get((e) => e.md5 == booruPost.md5 && e.postId == booruPost.id) !=
        null) {
      throw TaskExisted();
    }

    final entity = DownloadTableCompanion.insert(
      imgUrl: booruPost.imgURL,
      largerUrl: booruPost.sampleURL,
      previewUrl: booruPost.previewURL,
      md5: booruPost.md5,
      postId: booruPost.id,
      status: DownloadStatus.PENDING,
      quality: settingStore.downloadQuality,
      fileName: booruPost.imgURL.split('/').last,
      websiteId: mainStore.websiteEntity!.id,
      booruJson: jsonEncode(booruPost.toJson()),
    );
    await dao.insert(entity);
    await startDownload();
  }

  @action
  Future<void> restartDownload(DownloadTableData downloadTableData) async {
    downloadingList
        .get((task) => task.database.id == downloadTableData.id)
        ?.cancelToken
        .cancel();
    downloadingList
        .removeWhere((task) => task.database.id == downloadTableData.id);
    DB().downloadDao.replace(downloadTableData.copyWith(
          status: DownloadStatus.PENDING,
        ));
    await startDownload();
  }

  @action
  Future<void> deleteDownload(DownloadTableData downloadTableData) async {
    downloadingList
        .get((task) => task.database.id == downloadTableData.id)
        ?.cancelToken
        .cancel();

    downloadingList
        .removeWhere((task) => task.database.id == downloadTableData.id);
    DB().downloadDao.remove(downloadTableData);
  }

  @action
  Future<void> startDownload() async {
    await dao.startDownload();
    final pendingList = (await dao.getUnfinished()) // 取出数据库里等待中的
        .where((e) =>
            downloadingList.get((element) => element.database.id == e.id) ==
            null);
    for (final database in pendingList) {
      final websiteEntity = await DB().websiteDao.getById(database.websiteId);
      final dio = DioBuilder.build(websiteEntity);
      String downloadUrl = '';
      switch (settingStore.downloadQuality) {
        case ImageQuality.sample:
          downloadUrl = database.largerUrl;
          break;
        case ImageQuality.preview:
          downloadUrl = database.previewUrl;
          break;
        case ImageQuality.raw:
        default:
          downloadUrl = database.imgUrl;
          break;
      }
      downloadFile(database, dio, downloadUrl, database.fileName);
    }
  }

  @action
  Future<void> downloadFile(
      DownloadTableData database, Dio dio, String url, String fileName) async {
    print('开始下载 $fileName');
    final task = DownLoadTask(database);
    downloadingList.add(task);
    try {
      final rsp = await dio.get<Uint8List>(url,
          options: settingStore.dioCacheOptions
              .copyWith(policy: CachePolicy.noCache)
              .toOptions()
              .copyWith(responseType: ResponseType.bytes),
          cancelToken: task.cancelToken, onReceiveProgress: (count, total) {
        task.progress.value = count / total;
      });
      await saveBooruImage(fileName, rsp.data!);
      BotToast.showText(text: I18n.g.download_finish(' # ${database.postId} '));
      print('下载完成 $fileName');
      await dao.replace(task.database.copyWith(status: DownloadStatus.FINISH));
    } on DioError catch (e) {
      if (!CancelToken.isCancel(e)) {
        BotToast.showText(
            text: I18n.g.download_network_error + ': ${e.toString()}');
        await dao.replace(task.database.copyWith(status: DownloadStatus.FAIL));
      }
    } catch (e) {
      BotToast.showText(text: I18n.g.download_error + ': ${e.toString()}');
      await dao.replace(task.database.copyWith(status: DownloadStatus.FAIL));
    }
    downloadingList.remove(task);
  }
}
