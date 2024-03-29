import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/utils/utils.dart';
import 'package:dio/dio.dart';

class CookieInterceptor extends Interceptor {
  CookieInterceptor({
    required this.cookies,
    required this.websiteType,
    required this.host,
  });

  final String cookies;
  final int websiteType;
  final String host;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final baseCookies = options.headers['Cookie'] as String? ?? '';
    final currentCookies = Map.fromEntries(
        baseCookies.split(';').where((e) => e.isNotEmpty).map((e) {
      final data = e.split('=');
      return MapEntry(data[0].trim(), data.skip(1).join('=').trim());
    }));

    final userCookies =
        Map.fromEntries(cookies.split(';').where((e) => e.isNotEmpty).map((e) {
      final data = e.split('=');
      return MapEntry(data[0].trim(), data.skip(1).join('=').trim());
    }));
    currentCookies.addEntries(userCookies.entries);
    if (websiteType == WebsiteType.EHENTAI &&
        options.uri.host.contains(host.baseHost)) {
      currentCookies['nw'] = 'always';
    }
    options.headers['Cookie'] =
        currentCookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
    return handler.next(options);
  }
}
