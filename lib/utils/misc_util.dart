import 'package:catpic/data/database/entity/website_entity.dart';

String getSchemeString(int scheme) {
  if (scheme == null) return null;
  return scheme == WebsiteScheme.HTTP.index ? 'http' : 'https';
}

String getHost(String url) {
  var items = url
      .split('/')
      .where((e) => e != 'http:' && e != 'https:')
      .where((e) => e.isNotEmpty)
      .toList();
  return items.isNotEmpty ? items[0] : '';
}