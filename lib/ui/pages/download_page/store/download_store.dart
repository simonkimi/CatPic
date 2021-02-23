import 'dart:typed_data';

import 'package:catpic/ui/store/setting/setting_store.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'download_store.g.dart';

class DownloadStore = DownloadStoreBase with _$DownloadStore;

abstract class DownloadStoreBase with Store {
  var downloadList = ObservableList();

  @action
  Future<void> downloadFile(Dio dio, String url, String fileName) async {}
}
