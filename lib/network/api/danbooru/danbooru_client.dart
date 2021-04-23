import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/database/database.dart';
import 'package:dio/dio.dart';

import '../base_client.dart';

class DanbooruClient extends BaseClient {
  DanbooruClient(WebsiteTableData websiteEntity) : super(websiteEntity);

  // 获取Posts
  /// [limit] How many posts you want to retrieve. There is a default limit of 100 posts per request.
  /// [pid] The page number.
  /// [tags] The tags to search for. Any tag combination that works on the web site will work here. This includes all the meta-tags.
  Future<String> postsList({
    required int limit,
    required int page,
    required String tags,
  }) async {
    final baseUri = Uri.parse('posts.json');
    final uri = baseUri.replace(queryParameters: {
      ...baseUri.queryParameters,
      'limit': limit.toString(),
      'page': page.toString(),
      'tags': tags
    });

    return (await dio.getUri<String>(uri)).data ?? '';
  }

  /// 获取tag详细信息
  /// [limit] How many tags to retrieve. Setting this to 0 will return every tag.
  /// [name] The exact name of the tag.
  /// [page] The page number.
  Future<String> tagsList(
      {required int limit,
      required String name,
      required int page,
      Order order = Order.COUNT,
      CancelToken? cancelToken}) async {
    final uri = Uri(path: 'tag.json', queryParameters: <String, String>{
      'search[name_normalize]': name,
      'limit': limit.toString(),
      'order': order.string
    });

    return (await dio.getUri<String>(uri, cancelToken: cancelToken)).data!;
  }

  /// 获取评论
  /// [id] The id number of the comment to retrieve.
  Future<String> commentsList(String id) async {
    final uri = Uri(path: 'comments/$id.json');
    return (await dio.getUri<String>(uri)).data!;
  }

  /// 获取图集列表
  /// [query] The title.
  /// [page] The page.
  Future<String> poolList({required String name, required int page}) async {
    final uri = Uri(path: 'pool.json', queryParameters: {
      'search[name_matches]': name,
      'page': page.toString()
    });
    return (await dio.getUri<String>(uri)).data!;
  }

  /// 画师列表
  /// [name] The name (or a fragment of the name) of the artist.
  /// [id] The page number.
  Future<String> artistList({required String name, required int page}) async {
    final uri = Uri(path: 'artists.json', queryParameters: {
      'search[any_name_matches]': name,
      'page': page.toString()
    });
    return (await dio.getUri(uri)).data;
  }
}