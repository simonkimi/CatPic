import 'package:brotli/brotli.dart';
import 'package:dio/dio.dart';

class EncodeTransformer extends DefaultTransformer {

  @override
  Future transformResponse(RequestOptions options, ResponseBody response) async {
    if (response.headers['content-encoding']?.contains('br') ?? false) {
      return await brotli.decodeStream(response.stream);
    }
    return super.transformResponse(options, response);
  }
}