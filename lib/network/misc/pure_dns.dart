import 'dart:convert';

import 'package:dio/dio.dart';

Future<String> getTrustHost(String url) async {
  try {
    var query = 'https://cloudflare-dns.com/dns-query?name=$url&type=A';
    var req = await Dio().get(query,
        options: Options(headers: {'Accept': 'application/dns-json'}));
    var dataJson = json.decode(req.data);
    for (var host in dataJson['Answer']) {
      var reg = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');
      if (reg.hasMatch(host['data'])) {
        return host['data'];
      }
    }
    return '';
  } catch(e) {
    return '';
  }
}