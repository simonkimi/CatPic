import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioBuilder {
  static Dio build(BuildContext context, WebsiteEntity websiteEntity) {
    var dio = Dio()
      ..options.connectTimeout = 1000 * 10
      ..options.headers = {
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept-Language':
        'zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2',
        'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0'
      };

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) => true;
    };

    if (websiteEntity.useDomainFronting && Localizations.localeOf(context).countryCode == "CN") {
      dio.options.baseUrl = websiteEntity.host;
      dio.options.headers['Host'] = 'https://${websiteEntity.trustDns}/';
    } if (websiteEntity.trustDns.isNotEmpty) {
      var protocol = websiteEntity.protocol == WebsiteProtocol.HTTP.index ? 'http': 'https';
      dio.options.baseUrl = '$protocol://${websiteEntity.trustDns}/';
    } else {
      var protocol = websiteEntity.protocol == WebsiteProtocol.HTTP.index ? 'http': 'https';
      dio.options.baseUrl = '$protocol://${websiteEntity.host}/';
    }
    return dio;
  }
}