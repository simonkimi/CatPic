import 'dart:typed_data';

import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/ui/store/setting/setting_store.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/bridge/android_bridge.dart' as bridge;

part 'download_store.g.dart';

class DownloadStore = DownloadStoreBase with _$DownloadStore;

abstract class DownloadStoreBase with Store {
  var downloadList = ObservableList();

  @action
  Future<void> downloadFile(
      Dio dio, BooruPost booruPost, String fileName) async {
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
    final downloadPath = settingStore.downloadUri;
    final rsp = await dio.get<Uint8List>(downloadUrl,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (count, total) {
      // ignore: flutter_style_todos
      // TODO 更新下载进度
    });
    await bridge.writeFile(rsp.data, downloadUrl.split('/').last, downloadPath);
  }
}
