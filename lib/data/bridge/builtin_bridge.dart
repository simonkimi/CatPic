import 'dart:io';

import 'package:moor/moor.dart';
import 'package:path/path.dart';

Future<void> createDirectory(String path) async {
  final dir = Directory(path);
  if (dir.existsSync()) {
    return;
  }
  if (!dir.parent.existsSync()) {
    await createDirectory(dir.parent.path);
  }
  dir.create();
}

Future<void> writeFile(String path, String fileName, Uint8List data) async {
  final p = join(path, fileName);
  await createDirectory(path);
  final file = File(p);
  await file.writeAsBytes(data);
}

Future<List<String>> walkDir(String path) async {
  final dir = Directory(path);
  if (!dir.existsSync()) return [];
  return dir.listSync().map((e) => e.path.split('/').last).toList();
}

bool isFileExist(String path) => File(path).existsSync();
