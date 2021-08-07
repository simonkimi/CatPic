// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DownloadStore on DownloadStoreBase, Store {
  final _$downloadingListAtom = Atom(name: 'DownloadStoreBase.downloadingList');

  @override
  ObservableList<DownLoadTask> get downloadingList {
    _$downloadingListAtom.reportRead();
    return super.downloadingList;
  }

  @override
  set downloadingList(ObservableList<DownLoadTask> value) {
    _$downloadingListAtom.reportWrite(value, super.downloadingList, () {
      super.downloadingList = value;
    });
  }

  final _$createDownloadTaskAsyncAction =
      AsyncAction('DownloadStoreBase.createDownloadTask');

  @override
  Future<void> createDownloadTask(BooruPost booruPost) {
    return _$createDownloadTaskAsyncAction
        .run(() => super.createDownloadTask(booruPost));
  }

  final _$restartDownloadAsyncAction =
      AsyncAction('DownloadStoreBase.restartDownload');

  @override
  Future<void> restartDownload(dynamic downloadTableData) {
    return _$restartDownloadAsyncAction
        .run(() => super.restartDownload(downloadTableData));
  }

  final _$deleteDownloadAsyncAction =
      AsyncAction('DownloadStoreBase.deleteDownload');

  @override
  Future<void> deleteDownload(dynamic downloadTableData) {
    return _$deleteDownloadAsyncAction
        .run(() => super.deleteDownload(downloadTableData));
  }

  final _$startDownloadAsyncAction =
      AsyncAction('DownloadStoreBase.startDownload');

  @override
  Future<void> startDownload() {
    return _$startDownloadAsyncAction.run(() => super.startDownload());
  }

  final _$downloadFileAsyncAction =
      AsyncAction('DownloadStoreBase.downloadFile');

  @override
  Future<void> downloadFile(
      dynamic database, Dio dio, String url, String fileName) {
    return _$downloadFileAsyncAction
        .run(() => super.downloadFile(database, dio, url, fileName));
  }

  @override
  String toString() {
    return '''
downloadingList: ${downloadingList}
    ''';
  }
}
