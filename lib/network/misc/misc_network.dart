import 'dart:convert';
import 'dart:typed_data';
import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future<String> getDoH(String url) async {
  try {
    final query = 'https://cloudflare-dns.com/dns-query?name=$url&type=A';
    final dio = Dio()..options.connectTimeout = 10 * 1000;

    final req = await dio.get<String>(query,
        options: Options(headers: {'Accept': 'application/dns-json'}));

    final dataJson = json.decode(req.data);

    for (final host in dataJson['Answer']) {
      final reg = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');
      if (reg.hasMatch(host['data'])) {
        return host['data'];
      }
    }
    return '';
  } catch (e) {
    return '';
  }
}

Future<Uint8List> getFavicon(WebsiteEntity entity) async {
  try {
    print('获取网站图标 ${entity.name}');
    final dio = DioBuilder.build(entity);
    final req = await dio.get<Uint8List>('favicon.ico',
        options: Options(responseType: ResponseType.bytes));
    print('下载完成, 准备解码');
    MemoryImage(req.data);
    return req.data;
  } catch (e) {
    print('下载Favicon失败: $e');
    return Uint8List.fromList([]);
  }
}
