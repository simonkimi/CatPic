import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/network/client/dio_builder.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:catpic/network/api/ehentai/eh_url.dart';

class EhClient {
  Dio _dio;

  EhClient(BuildContext context, WebsiteEntity websiteEntity) {
    _dio = DioBuilder.build(context, websiteEntity);
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
