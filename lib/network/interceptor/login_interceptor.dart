import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:dio/dio.dart';
import 'package:catpic/utils/utils.dart';

class LoginInterceptor extends Interceptor {
  LoginInterceptor({
    required this.websiteEntity,
  });

  final WebsiteTableData websiteEntity;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (websiteEntity.type == WebsiteType.EHENTAI.index &&
        !options.uri.host.contains(websiteEntity.host.baseHost)) {
      final String cookies = options.headers['Cookie'] ?? '';
      final cookiesDict = Map.fromEntries(
          cookies.split(';').where((e) => e.isNotEmpty).map((e) {
        final data = e.split('=');
        return MapEntry(data[0].trim(), data.skip(1).join('=').trim());
      }));
      cookiesDict['nw'] = 'always';
      options.headers['Cookie'] =
          cookiesDict.entries.map((e) => '${e.key}=${e.value}').join('; ');
    }
    return handler.next(options);
  }
}
