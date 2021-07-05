import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'danbooru/danbooru_client.dart';
import 'gelbooru/gelbooru_client.dart';
import 'moebooru/moebooru_client.dart';

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
          if (host['type'] == 1) return host['data'] as String;
        }
      }
    }
    return '';
  } catch (e) {
    print('DoH失败: $e');
    return '';
  }
}

Future<Uint8List> getFavicon(Dio dio) async {
  try {
    print('获取网站图标');
    final req = await dio.get<Uint8List>('favicon.ico',
        options: Options(responseType: ResponseType.bytes));
    print('下载完成, 准备解码');
    if (req.data != null) {
      MemoryImage(req.data!).evict();
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

Future<int> getWebsiteType({
  required String host,
  required int scheme,
  required bool useDoH,
  required String cookies,
  required bool directLink,
  required bool onlyHost,
  required CancelToken cancelToken,
}) async {
  if (host.contains('e-hentai.org') || host.contains('exhentai.org'))
    return WebsiteType.EHENTAI;

  final websiteList = <int>[
    WebsiteType.GELBOORU,
    WebsiteType.MOEBOORU,
    WebsiteType.DANBOORU
  ];

  for (final type in websiteList) {
    final dio = DioBuilder.buildByBase(
        host: host,
        scheme: scheme,
        useDoH: useDoH,
        cookies: cookies,
        websiteType: type,
        directLink: directLink,
        onlyHost: onlyHost);

    try {
      switch (type) {
        case WebsiteType.GELBOORU:
          await GelbooruClient.fromDio(dio)
              .postsList(limit: 10, pid: 1, tags: '', cancelToken: cancelToken);
          return WebsiteType.GELBOORU;
        case WebsiteType.MOEBOORU:
          await MoebooruClient.fromDio(dio).postsList(
              limit: 10, page: 1, tags: '', cancelToken: cancelToken);
          return WebsiteType.MOEBOORU;
        case WebsiteType.DANBOORU:
          await DanbooruClient.fromDio(dio).postsList(
              limit: 10, page: 1, tags: '', cancelToken: cancelToken);
          return WebsiteType.DANBOORU;
        default:
          throw Exception('Unsupported');
      }
    } catch (e) {
      print('not ${type.string}');
    }
  }
  return WebsiteType.UNKNOWN;
}
