import 'package:catpic/data/models/booru/booru_website.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:dio/dio.dart';
import 'package:catpic/utils/utils.dart';

import '../base_client.dart';

class DanbooruClient extends BaseClient {
  DanbooruClient(BooruWebsiteEntity websiteEntity) : super(websiteEntity);

  DanbooruClient.fromDio(Dio dio) : super.fromDio(dio);

  // 获取Posts
  /// [limit] How many posts you want to retrieve. There is a default limit of 100 posts per request.
  /// [pid] The page number.
  /// [tags] The tags to search for. Any tag combination that works on the web site will work here. This includes all the meta-tags.
  Future<String> postsList({
    required int limit,
    required int page,
    required String tags,
    CancelToken? cancelToken,
  }) async {
    final baseUri = Uri.parse('posts.json');
    final uri = baseUri.replace(
        queryParameters: {
      ...baseUri.queryParameters,
      'limit': limit.toString(),
      'page': page.toString(),
      'tags': tags
    }.trim);

    return (await dio.getUri<String>(uri, cancelToken: cancelToken)).data ?? '';
  }

  Future<String> postSingle(int id) async {
    return (await dio.get<String>('posts/$id.json')).data!;
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
    final uri = Uri(
        path: 'tags.json',
        queryParameters: <String, String>{
          'search[name_matches]': name + '*',
          'limit': limit.toString(),
          'search[order]': order.string
        }.trim);
    return (await dio.getUri<String>(uri, cancelToken: cancelToken)).data!;
  }

  /// 获取评论
  /// [id] The id number of the comment to retrieve.
  Future<String> commentsList(String id) async {
    final uri = Uri(
        path: 'comments.json',
        queryParameters: {
          'search[post_id]': id,
        }.trim);
    return (await dio.getUri<String>(uri)).data!;
  }

  /// 获取图集列表
  /// [query] The title.
  /// [page] The page.
  Future<String> poolList({
    required String name,
    required int page,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri(
        path: 'pools.json',
        queryParameters:
            {'search[name_matches]': name, 'page': page.toString()}.trim);
    return (await dio.getUri<String>(uri, cancelToken: cancelToken)).data!;
  }

  /// 画师列表
  /// [name] The name (or a fragment of the name) of the artist.
  /// [id] The page number.
  Future<String> artistList({required String name, required int page}) async {
    final uri = Uri(
        path: 'artists.json',
        queryParameters:
            {'search[any_name_matches]': name, 'page': page.toString()}.trim);
    return (await dio.getUri<String>(uri)).data!;
  }

  Future<void> favourite({
    required String postId,
    required String username,
    required String apiKey,
  }) async {
    final uri =
        Uri(path: 'favorites.json', queryParameters: {'post_id': postId}.trim);

    await dio.postUri<String>(uri,
        data: {
          'login': username,
          'api_key': apiKey,
        }.trim);
  }

  Future<void> unFavourite({
    required String postId,
    required String username,
    required String apiKey,
  }) async {
    final uri = Uri(
        path: 'favorites/$postId.json',
        queryParameters: {
          'login': username,
          'api_key': apiKey,
        }.trim);
    await dio.deleteUri<String>(uri);
  }

  Future<String> hotByDayList({
    required String year,
    required String month,
    required String day,
    required String page,
    required String limit,
  }) async {
    final uri = Uri(
      path: 'explore/posts/popular.json',
      queryParameters: <String, String>{
        'date': '$year-$month-$day',
        'scale': 'day',
        'page': page,
        'limit': limit,
      },
    );
    return (await dio.getUri<String>(uri)).data!;
  }

  Future<String> hotByWeekList({
    required String year,
    required String month,
    required String day,
    required String page,
    required String limit,
  }) async {
    final uri = Uri(
      path: 'explore/posts/popular.json',
      queryParameters: <String, String>{
        'date': '$year-$month-$day',
        'scale': 'week',
        'page': page,
        'limit': limit,
      },
    );
    return (await dio.getUri<String>(uri)).data!;
  }

  Future<String> hotByMonthList({
    required String year,
    required String month,
    required String day,
    required String page,
    required String limit,
  }) async {
    final uri = Uri(
      path: 'explore/posts/popular.json',
      queryParameters: <String, String>{
        'date': '$year-$month-$day',
        'scale': 'month',
        'page': page,
        'limit': limit,
      },
    );
    return (await dio.getUri<String>(uri)).data!;
  }
}
