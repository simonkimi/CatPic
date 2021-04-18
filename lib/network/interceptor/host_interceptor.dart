import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:dio/dio.dart';
import 'package:catpic/utils/utils.dart';

class HostInterceptor extends Interceptor {
  HostInterceptor(
      {required this.directLink, required this.dio, required this.websiteId});

  final Dio dio;
  final bool directLink;
  final int websiteId;

  List<HostTableData> hostList = [];

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final uri = options.uri;
    if (hostList.isEmpty) {
      await updateHostLink();
    }
    final hostTargetData = hostList.get((e) => e.host == uri.host);
    var host = '';

    if (hostTargetData != null) {
      host = hostTargetData.host;
    } else {
      host = await getHost(uri.host);
    }

    if (host.isNotEmpty) {
      options.path = uri.replace(host: host).toString();
      if (directLink) {
        options.headers['Host'] = uri.host;
      }
    }

    return handler.next(options);
  }

  Future<void> updateHostLink() async {
    dio.lock();
    final hostDao = DatabaseHelper().hostDao;
    hostList = await hostDao.getAll();
    dio.unlock();
  }

  Future<String> getHost(String host) async {
    dio.lock();
    final ip = await getDoH(host);
    if (ip.isNotEmpty) {
      final hostDao = DatabaseHelper().hostDao;
      await hostDao.insert(
          HostTableCompanion.insert(host: host, ip: ip, websiteId: websiteId));
      hostList = await hostDao.getAll();
      dio.unlock();
      return ip;
    } else {
      dio.unlock();
      return '';
    }
  }
}
