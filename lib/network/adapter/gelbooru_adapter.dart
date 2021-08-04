import 'package:catpic/data/models/booru/booru_artist.dart';
import 'package:catpic/data/models/booru/booru_comment.dart';
import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:catpic/data/models/booru/booru_website.dart';
import 'package:catpic/network/parser/gelbooru/comment_parser.dart';
import 'package:catpic/network/parser/gelbooru/post_parser.dart';
import 'package:catpic/network/parser/gelbooru/tag_parser.dart';
import 'package:catpic/network/api/gelbooru/gelbooru_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'booru_adapter.dart';

class GelbooruAdapter implements BooruAdapter {
  GelbooruAdapter(this.websiteEntity) : client = GelbooruClient(websiteEntity);

  final BooruWebsiteEntity websiteEntity;

  @override
  final GelbooruClient client;

  @override
  List<SupportPage> getSupportPage() {
    return [SupportPage.POSTS, SupportPage.TAGS];
  }

  @override
  BooruWebsiteEntity get website => websiteEntity;

  @override
  Future<List<BooruPost>> postList({
    required String tags,
    required int page,
    required int limit,
    CancelToken? cancelToken,
  }) async {
    final str = await client.postsList(
        tags: tags, limit: limit, pid: page - 1, cancelToken: cancelToken);
    return await compute(GelbooruPostParser.parse, str);
  }

  @override
  Future<List<BooruTag>> tagList({
    required String name,
    required int page,
    required int limit,
    Order order = Order.COUNT,
    CancelToken? cancelToken,
  }) async {
    final str = await client.tagsList(
      limit: limit,
      names: name,
      order: order,
      cancelToken: cancelToken,
      page: page - 1,
    );
    return await compute(GelbooruTagParse.parse, str);
  }

  @override
  Dio get dio => client.dio;

  @override
  Future<List<BooruPool>> poolList({
    required String name,
    required int page,
  }) {
    throw UnsupportedError('Gelbooru not support Pool!');
  }

  @override
  Future<List<BooruComments>> comment({required String id}) async {
    final str = await client.commentsList(id);
    return await compute(GelbooruCommentParser.parse, str);
  }

  @override
  Future<List<BooruArtist>> artistList({
    required String name,
    required int page,
  }) {
    throw UnsupportedError('Gelbooru not support Artist!');
  }

  @override
  Future<void> favourite(String postId, String username, String password) {
    throw UnsupportedError('Gelbooru not support Favourite!');
  }

  @override
  String favouriteList(String username) {
    throw UnsupportedError('Gelbooru not support FavouriteList!');
  }

  @override
  Future<void> unFavourite(String postId, String username, String password) {
    throw UnsupportedError('Gelbooru not support Favourite!');
  }

  @override
  Future<List<BooruPost>> hotList({
    required int year,
    required int month,
    required int day,
    required PopularType popularType,
    required int page,
    required int limit,
  }) {
    throw UnsupportedError('Gelbooru not support Hot!');
  }
}
