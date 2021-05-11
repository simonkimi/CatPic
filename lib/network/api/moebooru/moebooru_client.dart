import 'dart:convert';

import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/data/database/database.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:catpic/utils/utils.dart';
import '../base_client.dart';

class MoebooruClient extends BaseClient {
  MoebooruClient(WebsiteTableData websiteEntity) : super(websiteEntity);

  /// 获取Posts
  /// [limit] How many posts you want to retrieve. There is a hard limit of 100
  /// [page] The page number.
  /// [tags] The tags to search for. Any tag combination that works on the web site will work here. This includes all the meta-tags.
  Future<String> postsList({
    required int limit,
    required int page,
    required String tags,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri(
        path: 'post.json',
        queryParameters: {
          'limit': limit.toString(),
          'page': page.toString(),
          'tags': tags
        }.trim);

    return (await dio.getUri<String>(uri, cancelToken: cancelToken)).data!;
  }

  /// 获取tag详细信息
  /// [limit] How many tags to retrieve. Setting this to 0 will return every tag.
  /// [name] The exact name of the tag.
  /// [page] The page number.
  Future<String> tagsList({
    required int limit,
    required String name,
    required int page,
    Order order = Order.COUNT,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri(
        path: 'tag.json',
        queryParameters: <String, String>{
          'name': name,
          'limit': limit.toString(),
          'order': order.string
        }.trim);

    return (await dio.getUri<String>(uri, cancelToken: cancelToken)).data!;
  }

  /// 获取评论列表
  /// [id] The id number of the comment to retrieve.
  Future<String> commentsList(String id) async {
    final uri =
        Uri(path: 'comment.json', queryParameters: {'post_id': id}.trim);
    return (await dio.getUri<String>(uri)).data!;
  }

  /// 获取图集列表
  /// [query] The title.
  /// [page] The page.
  Future<String> poolList({
    required String query,
    required int page,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri(
      path: 'pool.json',
      queryParameters: {'query': query, 'page': page.toString()}.trim,
    );
    return (await dio.getUri<String>(uri, cancelToken: cancelToken)).data!;
  }

  Future<String> poolSingle(String id) async {
    final uri = Uri(path: 'pool/show.json', queryParameters: {'id': id});
    return (await dio.getUri<String>(uri)).data!;
  }

  /// 获取图集详细内容
  /// [id] The pool id number.
  /// [page] The page.
  Future<String> postShow(int id, int page) async {
    final uri = Uri(
        path: 'pool/show.json',
        queryParameters: {'id': id.toString(), 'page': page.toString()}.trim);
    return (await dio.getUri(uri)).data;
  }

  /// 画师列表
  /// [name] The name (or a fragment of the name) of the artist.
  /// [id] The page number.
  Future<String> artistList({required String name, required int page}) async {
    final uri = Uri(
      path: 'artist.json',
      queryParameters: {'name': name, 'page': page.toString()}.trim,
    );
    return (await dio.getUri<String>(uri)).data!;
  }

  Future<void> favourite({
    required String postId,
    required String username,
    required String password,
  }) async {
    final uri = Uri(path: 'post/vote.json');

    await dio.postUri(uri,
        data: {
          'id': postId,
          'login': username,
          'score': '3',
          'password_hash': sha1
              .convert(utf8.encode('choujin-steiner--$password--'))
              .toString(),
        }.trim);
  }

  Future<void> unFavourite({
    required String postId,
    required String username,
    required String password,
  }) async {
    final uri = Uri(path: 'post/vote.json');

    await dio.postUri(uri,
        data: {
          'id': postId,
          'login': username,
          'score': '2',
          'password_hash': sha1
              .convert(utf8.encode('choujin-steiner--$password--'))
              .toString(),
        }.trim);
  }

  Future<String> hotByDayList({
    required String year,
    required String month,
    required String day,
  }) async {
    final uri = Uri(
      path: 'post/popular_by_day.json',
      queryParameters: {'day': day, 'month': month, 'year': year},
    );
    return (await dio.getUri<String>(uri)).data!;
  }

  Future<String> hotByWeekList({
    required String year,
    required String month,
    required String day,
  }) async {
    final uri = Uri(
      path: 'post/popular_by_week.json',
      queryParameters: {'day': day, 'month': month, 'year': year},
    );
    return (await dio.getUri<String>(uri)).data!;
  }

  Future<String> hotByMonthList({
    required String year,
    required String month,
    required String day,
  }) async {
    final uri = Uri(
      path: 'post/popular_by_month.json',
      queryParameters: {'day': day, 'month': month, 'year': year},
    );
    return (await dio.getUri<String>(uri)).data!;
  }
}
