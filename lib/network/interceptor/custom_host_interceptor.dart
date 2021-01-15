import 'package:catpic/data/database/database_helper.dart';
import 'package:dio/dio.dart';

class CustomHostInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    var uri = options.uri;
    var hostDao = DatabaseHelper().hostDao;
    var hostTarget = (await hostDao.getAll())
        .firstWhere((e) => e.host == uri.host, orElse: () => null);
    if (hostTarget != null) {
      var newUri = Uri(
              host: hostTarget.ip,
              queryParameters: uri.queryParameters,
              fragment: uri.fragment,
              path: uri.path,
              port: uri.port,
              scheme: uri.scheme,
              query: uri.query,
              userInfo: uri.userInfo)
          .toString();
      options.path = newUri;
      if (hostTarget.sni) {
        options.headers['Host'] = hostTarget.host;
      }
    }
    return options;
  }
}
