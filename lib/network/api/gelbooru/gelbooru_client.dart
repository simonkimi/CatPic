import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/database/database.dart';
import 'package:dio/dio.dart';
import 'package:catpic/utils/utils.dart';
import '../base_client.dart';

class GelbooruClient extends BaseClient {
  GelbooruClient(WebsiteTableData websiteEntity) : super(websiteEntity);

  /// 获取Posts
  /// [limit] How many posts you want to retrieve. There is a default limit of 100 posts per request.
  /// [pid] The page number.
  /// [tags] The tags to search for. Any tag combination that works on the web site will work here. This includes all the meta-tags.
  Future<String> postsList(
      {required int limit, required int pid, required String tags}) async {
    final baseUri = Uri.parse('index.php?page=dapi&s=post&q=index');
    final uri = baseUri.replace(
        queryParameters: {
      ...baseUri.queryParameters,
      'limit': limit.toString(),
      'pid': pid.toString(),
      'tags': tags
    }.trim);

    return (await dio.getUri<String>(uri)).data ?? '';
  }

  /// 获取tag详细信息
  /// [limit] How many tags you want to retrieve. There is a default limit of 100 per request.
  /// [names] Separated by spaces, get multiple results to tags you specify if it exists. (schoolgirl moon cat)
  Future<String> tagsList(
      {required int limit,
      required String names,
      Order order = Order.COUNT,
      CancelToken? cancelToken}) async {
    final baseUri = Uri.parse('index.php?page=dapi&s=tag&q=index');
    final uri = baseUri.replace(
        queryParameters: <String, String>{
      ...baseUri.queryParameters,
      'name_pattern': names + '%',
      'limit': limit.toString(),
      'order': order.string
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
