import 'dart:io';

import 'package:catpic/data/database/database.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/interceptor/encode_transform.dart';
import 'package:dio/dio.dart';
import 'package:catpic/network/interceptor/host_interceptor.dart';
import 'package:catpic/utils/utils.dart';
import 'package:dio/adapter.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class DioBuilder {
  static Dio build(WebsiteTableData? websiteEntity) {
    final dio = Dio()
      ..options.connectTimeout = 1000 * 60
      ..options.headers = {
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept-Language':
            'zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0'
      };
    if (websiteEntity == null) return dio;

    final scheme = getSchemeString(websiteEntity.scheme);
    dio.options.baseUrl = '$scheme://${websiteEntity.host}/';
    dio.transformer = EncodeTransformer();
    dio.interceptors.add(
      DioCacheInterceptor(options: settingStore.dioCacheOptions),
    );
    if (websiteEntity.useDoH) {
      dio.interceptors.add(HostInterceptor(
        dio: dio,
        directLink: websiteEntity.directLink,
        websiteId: websiteEntity.id,
      ));
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        return HttpClient()
          ..badCertificateCallback = (cert, host, port) => true;
      };
    }
    return dio;
  }
}

abstract class BaseClient {
  BaseClient(WebsiteTableData websiteEntity) {
    dio = DioBuilder.build(websiteEntity);
  }

  late Dio dio;
}
