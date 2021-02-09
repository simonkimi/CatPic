import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:dio/dio.dart';
import 'package:catpic/network/interceptor/custom_host_interceptor.dart';
import 'package:catpic/utils/misc_util.dart';
import 'package:dio/adapter.dart';

class DioBuilder {
  static Dio build(WebsiteEntity websiteEntity) {
    final dio = Dio()
      ..options.connectTimeout = 1000 * 10
      ..options.headers = {
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept-Language':
            'zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0'
      };
    final scheme = getSchemeString(websiteEntity.scheme);
    dio.options.baseUrl = '$scheme://${websiteEntity.host}/';
    if (websiteEntity.useDoH) {
      dio.interceptors.add(CustomHostInterceptor());
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) => true;
      };
    }
    return dio;
  }
}

abstract class BaseClient {
  BaseClient(WebsiteEntity websiteEntity) {
    dio = DioBuilder.build(websiteEntity);
  }

  Dio dio;
}
