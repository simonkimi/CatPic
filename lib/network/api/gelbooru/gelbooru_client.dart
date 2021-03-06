import 'package:catpic/data/database/entity/website_entity.dart';

import '../base_client.dart';

class GelbooruClient extends BaseClient {
  GelbooruClient(WebsiteEntity websiteEntity) : super(websiteEntity);

  /// 获取Posts
  /// [limit] How many posts you want to retrieve. There is a default limit of 100 posts per request.
  /// [pid] The page number.
  /// [tags] The tags to search for. Any tag combination that works on the web site will work here. This includes all the meta-tags.
  Future<String> postsList({int limit, int pid, String tags}) async {
    final baseUri = Uri.parse('index.php?page=dapi&s=post&q=index');
    final uri = baseUri.replace(queryParameters: {
      ...baseUri.queryParameters,
      'limit': (limit ?? 100).toString(),
      'pid': pid?.toString() ?? '',
      'tags': tags ?? ''
    });

    return (await dio.getUri<String>(uri)).data;
  }

  /// 获取tag详细信息
  /// [limit] How many tags you want to retrieve. There is a default limit of 100 per request.
  /// [names] Separated by spaces, get multiple results to tags you specify if it exists. (schoolgirl moon cat)
  Future<String> tagsList({int limit, String names}) async {
    final baseUri = Uri.parse('index.php?page=dapi&s=tag&q=index');
    final uri = baseUri.replace(queryParameters: {
      ...baseUri.queryParameters,
      'names': names ?? '',
      'limit': (limit ?? 100).toString()
    });

    return (await dio.getUri<String>(uri)).data;
  }



  /// 获取评论列表
  /// [postId] The id number of the comment to retrieve.
  Future<String> commentsList(String postId) async {
    final baseUri = Uri.parse('index.php?page=dapi&s=comment&q=index');
    final uri = baseUri.replace(queryParameters: {
      ...baseUri.queryParameters,
      'post_id': postId,
    });

    return (await dio.getUri<String>(uri)).data;
  }
}
