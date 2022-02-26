import 'package:catpic/data/models/ehentai/eh_website.dart';
import 'package:catpic/utils/utils.dart';
import 'package:dio/dio.dart';

import '../base_client.dart';

class EhClient extends BaseClient {
  EhClient(EhWebsiteEntity websiteEntity) : super(websiteEntity);

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

  // 单个画廊
  Future<String> getGallery(
      String gid, String gtoken, String page, CancelToken? cancelToken) async {
    return (await dio.get<String>(
      'g/$gid/$gtoken',
      queryParameters: <String, String>{'p': page, 'hc': '1'},
      cancelToken: cancelToken,
    ))
        .data!;
  }

  // 单张图片
  Future<String> galleryImage({
    required String shaToken,
    required String gid,
    required int page,
    CancelToken? cancelToken,
  }) async {
    return (await dio.get<String>('s/$shaToken/$gid-$page',
            cancelToken: cancelToken))
        .data!;
  }

  // 获取收藏列表
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

  // 添加进收藏
  Future<String> addToFavourite({
    required String gid,
    required String gtoken,
    required String favnote,
    required int favcat,
  }) async {
    return (await dio.post<String>(
      'gallerypopups.php',
      queryParameters: {
        'gid': gid,
        't': gtoken,
        'act': 'addfav',
      },
      data: FormData.fromMap({
        'favcat': favcat != -1 ? favcat.toString() : 'favdel',
        'favnote': favnote,
        'apply': favcat != -1 ? 'Add to Favorites' : 'Apply Changes',
        'update': '1',
      }),
    ))
        .data!;
  }
}
