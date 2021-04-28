import 'dart:convert';
import 'dart:typed_data';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future<String> getDoH(String url) async {
  final dio = Dio()
    ..options.connectTimeout = 60 * 1000
    ..options.headers = {
      'Accept': 'application/dns-json',
    };
  const dohList = [
    'https://dns.google/resolve',
    'https://cloudflare-dns.com/dns-query',
  ];

  try {
    for (final query in dohList) {
      final req = await dio
          .get<String>(query, queryParameters: {'name': url, 'type': 'A'});
      if (req.data != null) {
        final dataJson = json.decode(req.data!);
        for (final host in dataJson['Answer']) {
          final reg = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');
          if (reg.hasMatch(host['data'])) {
            return host['data'];
          }
        }
      }
    }
    return '';
  } catch (e) {
    print('DoH失败: $e');
    return '';
  }
}

Future<Uint8List> getFavicon(WebsiteTableData entity) async {
  try {
    print('获取网站图标 ${entity.name}');
    final dio = DioBuilder.build(entity);
    final req = await dio.get<Uint8List>('favicon.ico',
        options: Options(responseType: ResponseType.bytes));
    print('下载完成, 准备解码');
    if (req.data != null) {
      MemoryImage(req.data!);
      return req.data!;
    }
    throw Exception();
  } catch (e) {
    print('下载Favicon失败: $e');
    return Uint8List.fromList([]);
  }
}
