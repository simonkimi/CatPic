import 'package:catpic/data/database/entity/website_entity.dart';

import '../base_client.dart';


class EhClient extends BaseClient {
  EhClient(WebsiteEntity websiteEntity) : super(websiteEntity);

  /// 主页
  /// [filter] 过滤器, 由[buildSimpleFilter]和[buildAdvanceFilter]构建
  Future<String> getIndex(Map<String, dynamic> filter) async {
    return (await dio.get('', queryParameters: filter)).data;
  }

  /// 热门
  Future<String> getPopular() async {
    return (await dio.get('popular')).data;
  }
}
