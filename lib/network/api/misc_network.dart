import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

Future<String> getDoH(String url) async {
  final dio = Dio()
    ..options.connectTimeout = 60 * 1000
    ..options.headers = <String, String>{
      'Accept': 'application/dns-json',
    };
  const dohList = [
    'https://dns.google/resolve',
    'https://cloudflare-dns.com/dns-query',
  ];

  try {
    for (final query in dohList) {
      final req = await dio.get<String>(query,
          queryParameters: <String, String>{'name': url, 'type': 'A'});
      if (req.data != null) {
        final dataJson = json.decode(req.data!) as Map<String, dynamic>;
        for (final host in dataJson['Answer']) {
          final reg = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');
          if (reg.hasMatch(host['data'] as String)) {
            return host['data'] as String;
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

Future<Tuple2<String, String>> getEhVersion() async {
  const ehTranslateTagUrl =
      'https://api.github.com/repos/ehtagtranslation/Database/releases/latest';
  final dio = Dio()..options.connectTimeout = 60 * 1000;
  final data = (await dio.get<String>(ehTranslateTagUrl)).data!;
  final body = jsonDecode(data) as Map<String, dynamic>;
  return Tuple2(body['target_commitish']! as String, body['body']! as String);
}

Future<Map<String, dynamic>> getEhTranslate(String body) async {
  final dio = Dio()..options.connectTimeout = 60 * 1000;
  final reg = RegExp(r'<!--((.|\s)+?)-->');
  final match = reg.firstMatch(body)![1]!;
  final sha = jsonDecode(match)['mirror'] as String;

  final mirror = [
    'https://cdn.jsdelivr.net/gh/EhTagTranslation/DatabaseReleases@$sha/db.full.json.gz',
    'https://gitcdn.xyz/cdn/EhTagTranslation/DatabaseReleases/$sha/db.full.json.gz',
    'https://rawcdn.githack.com/EhTagTranslation/DatabaseReleases/$sha/db.full.json.gz',
    'https://cdn.statically.io/gh/EhTagTranslation/DatabaseReleases/$sha/db.full.json.gz'
  ];

  for (final url in mirror) {
    try {
      final jsonGz = await dio.get<List<int>>(url,
          options: Options(responseType: ResponseType.bytes));
      final jsonBytes = gzip.decode(jsonGz.data!);
      return jsonDecode(utf8.decode(jsonBytes)) as Map<String, dynamic>;
    } catch (e) {
      print('尝试$url失败: $e');
    }
  }
  throw Exception('失败');
}
