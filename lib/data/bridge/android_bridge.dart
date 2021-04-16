import 'dart:typed_data';

import 'package:flutter/services.dart';

const CHANNEL = 'ink.z31.catpic';

Future<String> getSAFUri() async {
  try {
    const platform = MethodChannel(CHANNEL);
    return await platform.invokeMethod('saf');
  } on PlatformException {
    return '';
  }
}

Future<String?> writeFile(Uint8List data, String fileName, String uri) async {
  try {
    const platform = MethodChannel(CHANNEL);
    return await platform.invokeMethod('save_image', {
      'data': data,
      'fileName': fileName,
      'uri': uri,
    });
  } on PlatformException catch (e) {
    print(e);
    return '';
  }
}
