import 'package:catpic/data/database/database.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:uuid/uuid.dart';
import 'package:catpic/utils/utils.dart';
import 'package:catpic/main.dart';
import '../base_client.dart';

class EhClient extends BaseClient {
  EhClient(WebsiteTableData websiteEntity) : super(websiteEntity);

  /// 主页
  /// [filter] 过滤器, 由[buildSimpleFilter]和[buildAdvanceFilter]构建
  Future<String> getIndex({
    required Map<String, dynamic> filter,
    required int page,
  }) async {
    return (await dio.get('', queryParameters: {
      ...filter,
      'page': page.toString(),
    }))
        .data;
  }

  /// 热门
  Future<String> getPopular() async {
    return (await dio.get('popular')).data;
  }

  Future<String> getGallery(
      String gid, String gtoken, String page, CancelToken? cancelToken) async {
    return (await dio.get('g/$gid/$gtoken',
            queryParameters: {'p': page, 'hc': '1'},
            cancelToken: cancelToken,
            options: settingStore.dioCacheOptions
                .copyWith(
                  policy: CachePolicy.request,
                  keyBuilder: (req) => const Uuid().v5(Uuid.NAMESPACE_URL,
                      '${dio.options.baseUrl}g/$gid/$gtoken?p=$page')
                    ..print('getGallery'),
                )
                .toOptions()))
        .data;
  }

  Future<String> galleryImage(String token, String galleryPage) async {
    return (await dio.get('s/$token/$galleryPage',
            options: settingStore.dioCacheOptions
                .copyWith(
                  policy: CachePolicy.request,
                  keyBuilder: (req) => const Uuid().v5(Uuid.NAMESPACE_URL,
                      '${dio.options.baseUrl}s/$token/$galleryPage')
                    ..print('galleryImage'),
                )
                .toOptions()))
        .data;
  }
}
