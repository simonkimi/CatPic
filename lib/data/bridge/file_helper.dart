import 'dart:io';

import 'package:moor/moor.dart';

import 'android_bridge.dart';

const MIME = <String, String>{
  'jpg': 'image/jpeg',
  'jpe': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'gif': 'image/gif',
  'png': 'image/png',
  'mp4': 'video/mp4',
};

Future<void> saveBooruImage(String fileName, Uint8List data) async {
  if (Platform.isAndroid) {
    await safWriteFile(
      safUrl: (await getSafUri())!,
      path: 'image',
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
  }
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
        mime: MIME[fileName.split('.').last] ?? 'application/octet-stream');
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
