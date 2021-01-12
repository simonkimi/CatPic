import 'dart:convert';
import 'dart:typed_data';

import 'package:catpic/network/client/dio_builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

Future<String> getTrustHost(String url) async {
  try {
    var query = 'https://cloudflare-dns.com/dns-query?name=$url&type=A';
    var dio = Dio()..options.connectTimeout = 10 * 1000;

    var req = await dio.get<String>(query,
        options: Options(headers: {'Accept': 'application/dns-json'}));

    var dataJson = json.decode(req.data);

    for (var host in dataJson['Answer']) {
      var reg = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');
      if (reg.hasMatch(host['data'])) {
        return host['data'];
      }
    }
    return '';
  } catch (e) {
    return '';
  }
}

Future<Uint8List> getFavicon({
  @required int protocol,
  @required String host,
  @required String trustHost,
  @required bool sni,
}) async {
  try {
    var dio = DioBuilder.get(
      protocol: protocol,
      host: host,
      trustHost: trustHost,
      sni: sni,
    )..options.connectTimeout = 30 * 1000;
    var req = await dio.get<List<int>>('favicon.ico',
        options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(req.data);
  } catch (e) {
    print("下载Favicon失败: $e");
    return Uint8List.fromList([]);
  }
}
