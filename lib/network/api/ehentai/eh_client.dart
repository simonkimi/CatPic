import 'package:catpic/data/database/database.dart';
import 'package:catpic/utils/utils.dart';
import '../base_client.dart';

class EhClient extends BaseClient {
  EhClient(WebsiteTableData websiteEntity) : super(websiteEntity);

  /// 主页
  /// [filter] 过滤器, 由[buildSimpleFilter]和[buildAdvanceFilter]构建
  Future<String> getIndex({
    required Map<String, dynamic> filter,
    required int page,
  }) async {
    return (await dio.get('',
            queryParameters: {
              ...filter,
              'page': page.toString(),
            }.trim))
        .data;
  }

  /// 热门
  Future<String> getPopular() async {
    return (await dio.get('popular')).data;
  }
}
