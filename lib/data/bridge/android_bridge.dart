import 'package:flutter/services.dart';

const CHANNEL = 'ink.z31.catpic';

Future<String> getSAFUri() async {
  try {
    const platform = MethodChannel(CHANNEL);
    return await platform.invokeMethod('saf');
  } on PlatformException catch (e) {
    return '';
  }
}
