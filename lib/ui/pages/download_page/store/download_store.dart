import 'dart:typed_data';

import 'package:catpic/ui/store/setting/setting_store.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'download_store.g.dart';

class DownloadStore = DownloadStoreBase with _$DownloadStore;

abstract class DownloadStoreBase with Store {
  var downloadList = ObservableList();

  @action
  Future<void> downloadFile(Dio dio, String url, String fileName) async {
    final downloadPath = settingStore.downloadUri;
    final rsp = await dio
        .get<Uint8List>(url, options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (count, total) {
      print('$count, $total');
    });
  }
}
