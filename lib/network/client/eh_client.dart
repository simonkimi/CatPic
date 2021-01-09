import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/ehentai/eh_url.dart';

class EhClient {
  Dio _dio;

  EhClient(BuildContext context, int siteType, bool useSni) {
    _dio = Dio()
      ..options.connectTimeout = 1000 * 10
      ..options.headers = {
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept-Language':
            'zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0'
      };

    if (siteType == EhUrl.SITE_E) {
      if (useSni && Localizations.localeOf(context).countryCode == "CN") {
        _dio.options.baseUrl = EhUrl.SNI_E;
        _dio.options.headers['Host'] = EhUrl.DOMAIN_E;
      } else {
        _dio.options.baseUrl = EhUrl.HOST_E;
      }
    } else if (siteType == EhUrl.SITE_EX) {
      if (useSni && Localizations.localeOf(context).countryCode == "CN") {
        _dio.options.baseUrl = EhUrl.SNI_EX;
        _dio.options.headers['Host'] = EhUrl.DOMAIN_EX;
      } else {
        _dio.options.baseUrl = EhUrl.HOST_EX;
      }
    }
  }

  Dio get dio => _dio;
}
