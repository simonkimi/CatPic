import 'package:catpic/data/database/entity/website.dart';

String? getSchemeString(int? scheme) {
  if (scheme == null) return null;
  return scheme == WebsiteScheme.HTTP.index ? 'http' : 'https';
}

extension StringHelper on String {
  String getHost() {
    final items = split('/')
        .where((e) => e != 'http:' && e != 'https:')
        .where((e) => e.isNotEmpty)
        .toList();
    return items.isNotEmpty ? items[0] : '';
  }

  int toInt() => int.tryParse(this) ?? 0;
}
