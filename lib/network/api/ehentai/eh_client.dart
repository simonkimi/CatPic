import 'package:catpic/data/database/database.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:uuid/uuid.dart';
import 'package:catpic/main.dart';
import 'package:catpic/utils/utils.dart';
import '../base_client.dart';

class EhClient extends BaseClient {
  EhClient(WebsiteTableData websiteEntity) : super(websiteEntity);

  EhClient.fromDio(Dio dio) : super.fromDio(dio);

  /// 主页
  /// [filter] 过滤器, 由[buildSimpleFilter]和[buildAdvanceFilter]构建
  Future<String> getIndex({
    required Map<String, dynamic> filter,
    required int page,
  }) async {
    return (await dio.get<String>(
      '',
      queryParameters: <String, dynamic>{
        ...filter,
        'page': page.toString(),
      },
    ))
        .data!;
  }

  /// 热门
  Future<String> getPopular() async {
    return (await dio.get<String>('popular')).data!;
  }

  /// 关注
  Future<String> getWatched({
    required Map<String, dynamic> filter,
    required int page,
  }) async {
    return (await dio.get<String>('watched', queryParameters: <String, dynamic>{
      ...filter,
      'page': page.toString()
    }))
        .data!;
  }

  Future<String> getGallery(
      String gid, String gtoken, String page, CancelToken? cancelToken) async {
    return (await dio.get<String>(
      'g/$gid/$gtoken',
      queryParameters: <String, String>{'p': page, 'hc': '1'},
      cancelToken: cancelToken,
    ))
        .data!;
  }

  Future<String> galleryImage({
    required String gtoken,
    required String gid,
    required int page,
  }) async {
    return (await dio.get<String>('s/$gtoken/$gid-$page',
            options: settingStore.dioCacheOptions
                .copyWith(
                  policy: CachePolicy.request,
                  keyBuilder: (req) => const Uuid().v5(Uuid.NAMESPACE_URL,
                      '${dio.options.baseUrl}s/$gtoken/$gid-$page'),
                )
                .toOptions()))
        .data!;
  }

  Future<String> favourite({
    required int favcat,
    required int page,
    required String searchText,
  }) async {
    return (await dio.get<String>(
      'favorites.php',
      queryParameters: <String, dynamic>{
        'page': page.toString(),
        'favcat': favcat != -1 ? favcat : '',
        'f_search': searchText,
        'sn': searchText.isNotEmpty ? 'on' : '',
        'st': searchText.isNotEmpty ? 'on' : '',
        'sf': searchText.isNotEmpty ? 'on' : '',
      }.trim,
    ))
        .data!;
  }
}
