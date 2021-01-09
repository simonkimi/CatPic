import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:catpic/network/api/ehentai/eh_url.dart';

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

  /// 主页
  /// [filter] 过滤器, 由[buildSimpleFilter]和[buildAdvanceFilter]构建
  Future<String> getIndex(Map<String, dynamic> filter) async {
    return (await _dio.get('', queryParameters: filter)).data;
  }


  /// 热门
  Future<String> getPopular() async {
    return (await _dio.get('popular')).data;
  }


}
