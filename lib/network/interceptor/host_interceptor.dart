import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:catpic/utils/utils.dart';
import 'package:dio/dio.dart';

const commonHost = <String, String>{
  'yande.re': '198.98.54.92',
  'files.yande.re': '198.98.54.92',
  'assets.yande.re': '198.98.54.92',
  'e-hentai.org': '104.20.134.21',
  'exhentai.org': '178.175.129.252',
  'gelbooru.com': '67.202.114.141',
};

class HostInterceptor extends Interceptor {
  HostInterceptor({
    required this.id,
    required this.onlyHost,
    required this.host,
    required this.dio,
    required this.directLink,
  });

  final int? id;
  final bool onlyHost;
  final Dio dio;
  final String host;
  final bool directLink;

  List<HostTableData> hostList = [];

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final uri = options.uri;
    if (onlyHost && !uri.host.contains(host.baseHost)) {
      return handler.next(options);
    }

    if (hostList.isEmpty) {
      await updateHostLink();
    }
    final hostTargetData = hostList.get((e) => e.host == uri.host);
    final ip = hostTargetData?.ip ?? await doh(uri.host);
    if (ip.isNotEmpty) {
      options.path = uri.replace(host: ip).toString();
      if (directLink) {
        options.headers['Host'] = uri.host;
      }
    }
    return handler.next(options);
  }

  Future<void> updateHostLink() async {
    dio.lock();
    final hostDao = DB().hostDao;
    hostList = await hostDao.getAll();
    dio.unlock();
  }

  Future<String> doh(String host) async {
    dio.lock();
    final ip =
        commonHost.containsKey(host) ? commonHost[host]! : await getDoH(host);
    if (ip.isNotEmpty) {
      final hostDao = DB().hostDao;
      await hostDao.insert(
          HostTableCompanion.insert(host: host, ip: ip, websiteId: id ?? -1));
      hostList = await hostDao.getAll();
      dio.unlock();
      return ip;
    } else {
      dio.unlock();
      return '';
    }
  }
}
