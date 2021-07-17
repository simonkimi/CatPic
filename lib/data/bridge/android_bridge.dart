import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

const _channel = MethodChannel('ink.z31.catpic');

Future<String?> requestSafUri() async {
  try {
    return await _channel.invokeMethod<String>('openSafDialog');
  } on PlatformException {
    return '';
  }
}

Future<String?> getSafUri() => _channel.invokeMethod('getSafUrl');

Future<void> safCreateDirectory(String safUrl, String path) => _channel
    .invokeMethod('safCreateDirectory', {'safUrl': safUrl, 'path': path});

Future<bool> safIsFileExist(String safUrl, String path, String fileName) async {
  return await _channel.invokeMethod('safIsFileExist',
      {'safUrl': safUrl, 'path': path, 'fileName': fileName}) as bool;
}

Future<void> safIsFile(String safUrl, String path, String fileName) =>
    _channel.invokeMethod(
        'safIsFile', {'safUrl': safUrl, 'path': path, 'fileName': fileName});

Future<void> safIsDirectory(String safUrl, String path, String fileName) =>
    _channel.invokeMethod('safIsDirectory',
        {'safIsDirectory': safUrl, 'path': path, 'fileName': fileName});

Future<List<String>> safWalk(String safUrl, String path) async {
  final data = await _channel.invokeMethod('safWalk', {
    'safUrl': safUrl,
    'path': path,
  }) as String;
  return (jsonDecode(data)['path']! as List<dynamic>).cast();
}

Future<Uint8List?> safReadFile(String safUrl, String path, String fileName) =>
    _channel.invokeMethod(
        'safReadFile', {'safUrl': safUrl, 'path': path, 'fileName': fileName});

Future<void> safDelFile(String safUrl, String path, String fileName) =>
    _channel.invokeMethod(
        'safDelFile', {'safUrl': safUrl, 'path': path, 'fileName': fileName});

Future<void> safWriteFile({
  required String safUrl,
  required String path,
  required String fileName,
  required String mime,
  required Uint8List data,
}) =>
    _channel.invokeMethod('safWriteFile', {
      'safUrl': safUrl,
      'path': path,
      'fileName': fileName,
      'mime': mime,
      'data': data
    });
