import 'dart:typed_data';

import 'package:flutter/services.dart';

const CHANNEL = 'ink.z31.catpic';

Future<String?> requestSafUri() async {
  try {
    const platform = MethodChannel(CHANNEL);
    return await platform.invokeMethod<String>('openSafDialog');
  } on PlatformException {
    return '';
  }
}

Future<String?> writeFile(Uint8List data, String fileName, String uri) async {
  try {
    const platform = MethodChannel(CHANNEL);
    return await platform.invokeMethod('saveImage', {
      'data': data,
      'fileName': fileName,
      'uri': uri,
    });
  } on PlatformException catch (e) {
    print('PlatformException ${e.toString()}');
    return '';
  }
}

Future<String?> getSafUri() =>
    const MethodChannel(CHANNEL).invokeMethod('getSafUrl');
