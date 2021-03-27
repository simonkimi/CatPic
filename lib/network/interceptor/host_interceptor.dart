import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/misc/misc_network.dart';
import 'package:dio/dio.dart';

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
    final hostTargetList = hostList.where((e) => e.host == uri.host);
    if (hostTargetList.isNotEmpty) {
      final hostTarget = await getHost(uri.host);

      if (hostTarget.isNotEmpty) {
        options.path = uri.replace(host: hostTarget).toString();
        if (directLink) {
          options.headers['Host'] = uri.host;
        }
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
