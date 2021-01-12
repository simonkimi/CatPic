import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioBuilder {
  static Dio buildBaseDio() {
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
    return dio;
  }

  static Dio build(BuildContext context, WebsiteEntity websiteEntity) {
    var dio = buildBaseDio();
    var protocol =
        websiteEntity.protocol == WebsiteProtocol.HTTP.index ? 'http' : 'https';
    if (websiteEntity.useDomainFronting) {
      dio.options.baseUrl = '$protocol://${websiteEntity.trustHost}/';
      dio.options.headers['Host'] = '${websiteEntity.host}';
    } else if (websiteEntity.trustHost.isNotEmpty) {
      dio.options.baseUrl = '$protocol://${websiteEntity.trustHost}/';
    } else {
      dio.options.baseUrl = '$protocol://${websiteEntity.host}/';
    }
    return dio;
  }

  static Dio get({
    @required int protocol,
    @required String host,
    @required String trustHost,
    @required bool sni,
  }) {
    var dio = buildBaseDio();
    var protocolStr = protocol == WebsiteProtocol.HTTP.index ? 'http' : 'https';
    if (sni) {
      dio.options.baseUrl = '$protocolStr://$trustHost/';
      dio.options.headers['Host'] = '$host';
    } else if (trustHost.isNotEmpty) {
      dio.options.baseUrl = '$protocolStr://$trustHost/';
    } else {
      dio.options.baseUrl = '$protocolStr://$host/';
    }
    return dio;
  }
}
