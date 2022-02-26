import 'package:catpic/data/models/booru/booru_website.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/utils/utils.dart';
import 'package:dio/dio.dart';

import '../base_client.dart';

class GelbooruClient extends BaseClient {
  GelbooruClient(BooruWebsiteEntity websiteEntity) : super(websiteEntity);

  GelbooruClient.fromDio(Dio dio) : super.fromDio(dio);

  /// 获取Posts
  /// [limit] How many posts you want to retrieve. There is a default limit of 100 posts per request.
  /// [pid] The page number.
  /// [tags] The tags to search for. Any tag combination that works on the web site will work here. This includes all the meta-tags.
  Future<String> postsList(
      {required int limit,
      required int pid,
      required String tags,
      CancelToken? cancelToken}) async {
    final baseUri = Uri.parse('index.php?page=dapi&s=post&q=index');
    final uri = baseUri.replace(
        queryParameters: {
      ...baseUri.queryParameters,
      'limit': limit.toString(),
      'pid': pid.toString(),
      'tags': tags
    }.trim);

    return (await dio.getUri<String>(uri, cancelToken: cancelToken)).data ?? '';
  }

  /// 获取tag详细信息
  /// [limit] How many tags you want to retrieve. There is a default limit of 100 per request.
  /// [names] Separated by spaces, get multiple results to tags you specify if it exists. (schoolgirl moon cat)
  Future<String> tagsList({
    required int limit,
    required String names,
    required int page,
    Order order = Order.COUNT,
    CancelToken? cancelToken,
  }) async {
    final baseUri = Uri.parse('index.php?page=dapi&s=tag&q=index');
    final uri = baseUri.replace(
        queryParameters: <String, String>{
      ...baseUri.queryParameters,
      'name_pattern': names + '%',
      'limit': limit.toString(),
      'orderby': order.string,
      'pid': page.toString(),
    }.trim);
    return (await dio.getUri<String>(uri, cancelToken: cancelToken)).data ?? '';
  }

  /// 获取评论列表
  /// [postId] The id number of the comment to retrieve.
  Future<String> commentsList(String postId) async {
    final baseUri = Uri.parse('index.php?page=dapi&s=comment&q=index');
    final uri = baseUri.replace(
        queryParameters: {
      ...baseUri.queryParameters,
      'post_id': postId,
    }.trim);
    return (await dio.getUri<String>(uri)).data ?? '';
  }
}
