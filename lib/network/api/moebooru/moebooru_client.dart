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

  /// 获取图集列表, 加载20个
  /// [query] The title.
  /// [page] The page.
  Future<String> poolList({String query, int page}) async {
    var uri = Uri(
        path: 'pool.json',
        queryParameters: {
          'query': query,
          'page': page.toString()
        }
    );
    return (await dio.getUri(uri)).data;
  }

  /// 获取图集详细内容
  /// [id] The pool id number.
  /// [page] The page.
  Future<String> postShow(int id, int page) async {
    var uri = Uri(
        path: 'pool/show.json',
        queryParameters: {
          'id': id.toString(),
          'page': page.toString()
        }
    );
    return (await dio.getUri(uri)).data;
  }

  /// 画师列表
  /// [name] The name (or a fragment of the name) of the artist.
  /// [id] The page number.
  Future<String> artistList({String name, int page}) async {
    var uri = Uri(
        path: 'artist.json',
        queryParameters: {
          'name': name,
          'page': page.toString()
        }
    );
    return (await dio.getUri(uri)).data;
  }
}
