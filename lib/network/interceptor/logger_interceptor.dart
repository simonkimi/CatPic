import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LoggerInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    debugPrint(
        '\n================================= 请求数据 =================================');
    debugPrint('method = ${options.method.toString()}');
    debugPrint('url = ${options.uri.toString()}');
    debugPrint('headers = ${options.headers}');
    debugPrint('params = ${options.queryParameters}');
    return options;
  }

  @override
  Future onError(DioError err) async {
    debugPrint(
        '\n=================================错误响应数据 =================================');
    debugPrint('type = ${err.type}');
    debugPrint('message = ${err.message}');
    debugPrint('\n');
    return err;
  }

  @override
  Future onResponse(Response response) async {
    debugPrint(
        '\n================================= 响应数据开始 =================================');
    debugPrint('code = ${response.statusCode}');
    debugPrint('data = ${response.data}');
    debugPrint(
        '================================= 响应数据结束 =================================\n');
    return response;
  }
}
