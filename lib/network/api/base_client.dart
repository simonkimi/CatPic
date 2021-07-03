import 'dart:io';

import 'package:catpic/data/database/database.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/interceptor/encode_transform.dart';
import 'package:catpic/network/interceptor/cookie_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:catpic/network/interceptor/host_interceptor.dart';
import 'package:catpic/utils/utils.dart';
import 'package:dio/adapter.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class DioBuilder {
  static Dio build(WebsiteTableData? websiteEntity) {
    final dio = buildDio();
    dio.interceptors
        .add(DioCacheInterceptor(options: settingStore.dioCacheOptions));
    if (websiteEntity == null) return dio;
    final scheme = getSchemeString(websiteEntity.scheme);
    dio.options.baseUrl = '$scheme://${websiteEntity.host}/';
    dio.transformer = EncodeTransformer();
    dio.interceptors.add(CookieInterceptor(
      cookies: websiteEntity.cookies,
      host: websiteEntity.host,
      websiteType: websiteEntity.type,
    ));

    if (websiteEntity.useDoH) {
      dio.interceptors.add(HostInterceptor(
        dio: dio,
        onlyHost: websiteEntity.onlyHost,
        host: websiteEntity.host,
        directLink: websiteEntity.directLink,
        id: websiteEntity.id,
      ));
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        return HttpClient()
          ..badCertificateCallback = (cert, host, port) => true;
      };
    }
    return dio;
  }

  static Dio buildByBase({
    required String host,
    required int scheme,
    required bool useDoH,
    required String cookies,
    required int websiteType,
    required bool directLink,
    required bool onlyHost,
  }) {
    final dio = buildDio();
    final schemeString = getSchemeString(scheme);
    dio.options.baseUrl = '$schemeString://$host/';
    dio.transformer = EncodeTransformer();
    dio.interceptors.add(CookieInterceptor(
      cookies: cookies,
      host: host,
      websiteType: websiteType,
    ));

    if (useDoH) {
      dio.interceptors.add(HostInterceptor(
          dio: dio,
          directLink: directLink,
          host: host,
          id: null,
          onlyHost: onlyHost));
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        return HttpClient()
          ..badCertificateCallback = (cert, host, port) => true;
      };
    }
    return dio;
  }

  static Dio buildDio() {
    return Dio()
      ..options.connectTimeout = 1000 * 5
      ..options.receiveTimeout = 1000 * 5
      ..options.sendTimeout = 1000 * 5
      ..options.headers = <String, String>{
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept-Language':
            'zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0'
      };
  }
}

abstract class BaseClient {
  BaseClient(WebsiteTableData websiteEntity) {
    dio = DioBuilder.build(websiteEntity);
  }

  late Dio dio;
}
