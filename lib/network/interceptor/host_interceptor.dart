import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:dio/dio.dart';
import 'package:catpic/utils/utils.dart';

const commonHost = <String, String>{
  'yande.re': '198.98.54.92',
  'files.yande.re': '198.98.54.92',
  'assets.yande.re': '198.98.54.92',
  'e-hentai.org': '104.20.134.21',
  'exhentai.org': '178.175.129.252',
};

class HostInterceptor extends Interceptor {
  HostInterceptor({
    required this.websiteEntity,
    required this.dio,
  });

  final WebsiteTableData websiteEntity;
  final Dio dio;

  List<HostTableData> hostList = [];

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final uri = options.uri;
    if (websiteEntity.onlyHost &&
        !uri.host.contains(websiteEntity.host
            .split('.')
            .reversed
            .take(2)
            .toList()
            .reversed
            .join('.'))) {
      return handler.next(options);
    }

    if (hostList.isEmpty) {
      await updateHostLink();
    }
    final hostTargetData = hostList.get((e) => e.host == uri.host);
    final ip = hostTargetData?.ip ?? await doh(uri.host);
    if (ip.isNotEmpty) {
      options.path = uri.replace(host: ip).toString();
      if (websiteEntity.directLink) {
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

  Future<String> doh(String host) async {
    dio.lock();
    final ip =
        commonHost.containsKey(host) ? commonHost[host]! : await getDoH(host);
    if (ip.isNotEmpty) {
      final hostDao = DatabaseHelper().hostDao;
      await hostDao.insert(HostTableCompanion.insert(
          host: host, ip: ip, websiteId: websiteEntity.id));
      hostList = await hostDao.getAll();
      dio.unlock();
      return ip;
    } else {
      dio.unlock();
      return '';
    }
  }
}
