import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/host_entity.dart';
import 'package:dio/dio.dart';

class CustomHostInterceptor extends Interceptor {
  List<HostEntity> hostList = [];

  @override
  Future onRequest(RequestOptions options) async {
    var uri = options.uri;

    if (hostList.isEmpty) {
      var hostDao = DatabaseHelper().hostDao;
      hostList = await hostDao.getAll();
    }

    var hostTarget =
        hostList.firstWhere((e) => e.host == uri.host, orElse: () => null);
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
