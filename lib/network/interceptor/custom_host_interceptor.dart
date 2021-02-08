import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/host_entity.dart';
import 'package:dio/dio.dart';

class CustomHostInterceptor extends Interceptor {
  List<HostEntity> hostList = [];

  @override
  Future onRequest(RequestOptions options) async {
    final uri = options.uri;
    if (hostList.isEmpty) {
      final hostDao = DatabaseHelper().hostDao;
      hostList = await hostDao.getAll();
    }

    final hostTarget =
        hostList.firstWhere((e) => e.host == uri.host, orElse: () => null);
    if (hostTarget != null) {
      options.path = uri.replace(host: hostTarget.ip).toString();
      if (hostTarget.sni) {
        options.headers['Host'] = hostTarget.host;
      }
    }
    return options;
  }
}
