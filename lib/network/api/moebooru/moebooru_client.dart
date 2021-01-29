import 'package:catpic/data/database/entity/website_entity.dart';

import '../base_client.dart';

class MoebooruClient extends BaseClient {
  MoebooruClient(WebsiteEntity websiteEntity) : super(websiteEntity);

  /// 获取Posts
  /// [limit] How many posts you want to retrieve. There is a hard limit of 100
  /// [page] The page number.
  /// [tags] The tags to search for. Any tag combination that works on the web site will work here. This includes all the meta-tags.
  Future<String> postsList({int limit, int page, String tags}) async {
    var uri = Uri(path: 'post.json', queryParameters: {
      'limit': limit ?? 100,
      'page': page ?? '',
      'tags': tags ?? ''
    });

    return (await dio.getUri(uri)).data;
  }

  /// 获取tag详细信息
  /// [limit] How many tags to retrieve. Setting this to 0 will return every tag.
  /// [name] The exact name of the tag.
  /// [page] The page number.
  Future<String> tagsList({int limit, String name, int page}) async {
    var uri = Uri(path: 'tag.json', queryParameters: {
      'name': name ?? '',
      'limit': limit ?? 100,
    });

    return (await dio.getUri(uri)).data;
  }

  /// 获取评论列表
  /// [id] The id number of the comment to retrieve.
  Future<String> commentsList(String id) async {
    var uri = Uri(
      path: 'comment/show.json',
      queryParameters: {
        'id': id
      }
    );
    return (await dio.getUri(uri)).data;
  }
}
