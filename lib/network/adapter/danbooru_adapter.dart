import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/booru_artist.dart';
import 'package:catpic/data/models/booru/booru_comment.dart';
import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:catpic/network/parser/danbooru/artist_parser.dart';
import 'package:catpic/network/parser/danbooru/comment_parser.dart';
import 'package:catpic/network/parser/danbooru/pool_parser.dart';
import 'package:catpic/network/parser/danbooru/post_parser.dart';
import 'package:catpic/network/parser/danbooru/tag_parser.dart';
import 'package:catpic/network/api/danbooru/danbooru_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'booru_adapter.dart';

class DanbooruAdapter implements BooruAdapter {
  DanbooruAdapter(this.websiteEntity) {
    client = DanbooruClient(websiteEntity);
  }

  final WebsiteTableData websiteEntity;

  @override
  late DanbooruClient client;

  @override
  List<SupportPage> getSupportPage() {
    return [
      SupportPage.ARTISTS,
      SupportPage.POSTS,
      SupportPage.TAGS,
      SupportPage.POOLS,
      SupportPage.FAVOURITE,
    ];
  }

  @override
  Future<List<BooruPost>> postList(
      {required String tags,
      required int page,
      required int limit,
      CancelToken? cancelToken,
      Order order = Order.COUNT}) async {
    final str = await client.postsList(
        tags: tags, limit: limit, page: page, cancelToken: cancelToken);

    return await compute(DanbooruPostParse.parse, str);
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
      name: name,
      page: page,
      order: order,
      cancelToken: cancelToken,
    );
    return await compute(DanbooruTagParser.parse, str);
  }

  @override
  Future<List<BooruPool>> poolList({
    required String name,
    required int page,
    CancelToken? cancelToken,
  }) async {
    final str = await client.poolList(
      name: name,
      page: page,
      cancelToken: cancelToken,
    );
    return await compute(DanbooruPoolParser.parse, str);
  }

  @override
  Dio get dio => client.dio;

  @override
  Future<List<BooruArtist>> artistList({
    required String name,
    required int page,
  }) async {
    final str = await client.artistList(
      name: name,
      page: page,
    );
    return await compute(DanbooruArtistParser.parse, str);
  }

  @override
  Future<List<BooruComments>> comment({required String id}) async {
    final str = await client.commentsList(id);
    return await compute(DanbooruCommentParser.parse, str);
  }

  @override
  String favouriteList(String username) => 'ordfav:$username';

  @override
  Future<void> favourite(
      String postId, String username, String password) async {
    await client.favourite(
        postId: postId, username: username, apiKey: password);
  }
}
