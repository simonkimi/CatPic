import 'dart:io';

import 'package:catpic/ui/pages/booru_page/download_page/android_download.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import 'android_bridge.dart';

const MIME = <String, String>{
  'jpg': 'image/jpeg',
  'jpe': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'gif': 'image/gif',
  'png': 'image/png',
  'mp4': 'video/mp4',
};

Future<bool> hasDownloadPermission() async {
  if (Platform.isAndroid) {
    return (await getSafUri()) != null;
  }
  throw UnsupportedError('');
}

void requestDownloadPath(BuildContext context) {
  if (Platform.isAndroid) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AndroidDownloadPage()));
    return;
  }
  throw UnsupportedError('');
}

Future<void> saveBooruImage(String fileName, Uint8List data) async {
  if (Platform.isAndroid) {
    await safWriteFile(
      safUrl: (await getSafUri())!,
      path: 'Image',
      fileName: fileName,
      mime: MIME[fileName.split('.').last] ?? 'application/octet-stream',
      data: data,
    );
  }
}

Future<void> createDir(String path) async {
  if (Platform.isAndroid) {
    final saf = await getSafUri();
    await safCreateDirectory(saf!, path);
    return;
  }
  throw UnsupportedError('');
}

Future<Uint8List?> readFile(String path, String fileName) async {
  if (Platform.isAndroid) {
    final saf = await getSafUri();
    return await safReadFile(saf!, path, fileName);
  }
  throw UnsupportedError('');
}

Future<void> writeFile(String path, String fileName, Uint8List data) async {
  if (Platform.isAndroid) {
    final saf = await getSafUri();
    await safWriteFile(
      safUrl: saf!,
      path: path,
      data: data,
      fileName: fileName,
      mime: MIME[fileName.split('.').last] ?? 'application/octet-stream',
    );
    return;
  }
  throw UnsupportedError('');
}

Future<List<String>> walk(String path) async {
  if (Platform.isAndroid) {
    final saf = await getSafUri();
    return await safWalk(saf!, path);
  }
  throw UnsupportedError('');
}

Future<bool> isFileExist(String path, String fileName) async {
  if (Platform.isAndroid) {
    final saf = await getSafUri();
    return await safIsFileExist(saf!, path, fileName);
  }
  throw UnsupportedError('');
}

Future<void> delFile(String path, String fileName) async {
  if (Platform.isAndroid) {
    final saf = await getSafUri();
    return await safDelFile(saf!, path, fileName);
  }
  throw UnsupportedError('');
}
