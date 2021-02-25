import 'dart:typed_data';

import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/download_entity.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/ui/store/main/main_store.dart';
import 'package:catpic/ui/store/setting/setting_store.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/bridge/android_bridge.dart' as bridge;

part 'download_store.g.dart';

final downloadStore = DownloadStore();

class DownloadStore = DownloadStoreBase with _$DownloadStore;

abstract class DownloadStoreBase with Store {
  var downloadList = ObservableList<DownloadEntity>();

  Future<void> init() async {
    final dao = DatabaseHelper().downloadDao;
    downloadList.addAll(await dao.getALL());
  }

  @action
  Future<void> createDownloadTask(Dio dio, BooruPost booruPost) async {
    String downloadUrl = '';
    switch (settingStore.downloadQuality) {
      case ImageQuality.sample:
        downloadUrl = booruPost.sampleURL;
        break;
      case ImageQuality.preview:
        downloadUrl = booruPost.previewURL;
        break;
      case ImageQuality.raw:
      default:
        downloadUrl = booruPost.imgURL;
        break;
    }
    final entity = DownloadEntity(
        imgUrl: booruPost.imgURL,
        largerUrl: booruPost.sampleURL,
        previewUrl: booruPost.previewURL,
        md5: booruPost.md5,
        progress: 0,
        postId: booruPost.id,
        quality: settingStore.downloadQuality,
        websiteId: mainStore.websiteEntity.id);
    downloadList.add(entity);
    await downloadFile(dio, downloadUrl, downloadUrl.split('/').last, entity);
  }

  @action
  Future<void> downloadFile(
      Dio dio, String url, String fileName, DownloadEntity entity) async {
    final downloadPath = settingStore.downloadUri;
    final rsp = await dio
        .get<Uint8List>(url, options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (count, total) {
      entity.progress = count / total;
    });
    entity.progress = 1;
    await bridge.writeFile(rsp.data, fileName, downloadPath);
  }
}
