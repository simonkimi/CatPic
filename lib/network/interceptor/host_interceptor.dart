import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/host_entity.dart';
import 'package:catpic/network/misc/misc_network.dart';
import 'package:dio/dio.dart';

class HostInterceptor extends Interceptor {
  HostInterceptor(
      {required this.directLink, required this.dio, required this.websiteId});

  final Dio dio;
  final bool directLink;
  final int websiteId;

  List<HostEntity> hostList = [];

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
      final entity = HostEntity(host: host, ip: ip, websiteId: websiteId);
      await hostDao.addHost(entity);
      hostList.add(entity);
      dio.lock();
      return ip;
    } else {
      dio.lock();
      return '';
    }
  }
}
