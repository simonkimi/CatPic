import 'dart:typed_data';

import 'package:brotli/brotli.dart';
import 'package:dio/dio.dart';

class EncodeTransformer extends DefaultTransformer {
  @override
  Future transformResponse(
      RequestOptions options, ResponseBody response) async {
    if (response.headers['content-encoding']?.contains('br') ?? false) {
      if (options.responseType == ResponseType.bytes) {
        final data = <int>[];
        await response.stream.forEach(data.addAll);
        return brotli.decode(Uint8List.fromList(data));
      }
      return await brotli.decodeStream(response.stream);
    }
    return super.transformResponse(options, response);
  }
}
