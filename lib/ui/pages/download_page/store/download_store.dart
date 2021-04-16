import 'dart:convert';
import 'dart:typed_data';

import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/download.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/store/main/main_store.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/bridge/android_bridge.dart' as bridge;

part 'download_store.g.dart';

final downloadStore = DownloadStore();

class DownloadStore = DownloadStoreBase with _$DownloadStore;

class TaskExisted implements Exception {}

class WebsiteNotExisted implements Exception {}

class DownLoadTask {
  DownLoadTask(this.database);

  final DownloadTableData database;
  var progress = 0.0;

  @override
  String toString() {
    return '${database.fileName} $progress';
  }
}

abstract class DownloadStoreBase with Store {
  var downloadingList = ObservableList<DownLoadTask>();

  final dao = DatabaseHelper().downloadDao;

  @action
  Future<void> createDownloadTask(BooruPost booruPost) async {
    final taskList = await dao.getAll();

    print(taskList);

    if (taskList
        .where((e) => e.md5 == booruPost.md5 && e.postId == booruPost.id)
        .isNotEmpty) {
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
    // await startDownload();
  }

  @action
  Future<void> startDownload() async {
    final pendingList = (await dao.getAll())
        .where((e) => e.status == DownloadStatus.PENDING) // 取出数据库里等待中的
        .where((e) => downloadingList
            .where((element) => element.database.id == e.id) // 排除正在下载列表里的
            .isEmpty);
    for (final database in pendingList) {
      final websiteDao = DatabaseHelper().websiteDao;
      final websiteEntity = await websiteDao.getById(database.id);
      if (websiteEntity != null) {
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
  }

  @action
  Future<void> downloadFile(
      DownloadTableData database, Dio dio, String url, String fileName) async {
    final task = DownLoadTask(database);
    downloadingList.add(task);
    final downloadPath = settingStore.downloadUri;
    final rsp = await dio
        .get<Uint8List>(url, options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (count, total) {
      task.progress = count / total;
    });
    await bridge.writeFile(rsp.data!, fileName, downloadPath);
    downloadingList.remove(task);
    await dao.replace(task.database.copyWith(status: DownloadStatus.FINISH));
  }
}
