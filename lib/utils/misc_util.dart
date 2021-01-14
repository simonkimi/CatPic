import 'package:catpic/data/database/entity/website_entity.dart';

String getProtocolString(int protocol) {
  if (protocol == null) return null;
  return protocol == WebsiteProtocol.HTTP.index ? 'http' : 'https';
}

String getHost(String url) {
  var items = url
      .split('/')
      .where((e) => e != 'http:' && e != 'https:')
      .where((e) => e.isNotEmpty)
      .toList();
  return items.isNotEmpty ? items[0] : '';
}