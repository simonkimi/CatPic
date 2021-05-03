import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/booru_artist.dart';
import 'package:catpic/data/models/booru/booru_comment.dart';
import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:catpic/network/parser/moebooru/artist_parser.dart';
import 'package:catpic/network/parser/moebooru/comment_parser.dart';
import 'package:catpic/network/parser/moebooru/pool_parser.dart';
import 'package:catpic/network/parser/moebooru/post_parser.dart';
import 'package:catpic/network/parser/moebooru/tag_parser.dart';
import 'package:catpic/network/api/moebooru/moebooru_client.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/dio.dart';
import 'package:flutter/foundation.dart';

import 'booru_adapter.dart';

class MoebooruAdapter implements BooruAdapter {
  MoebooruAdapter(this.websiteEntity) {
    client = MoebooruClient(websiteEntity);
  }

  final WebsiteTableData websiteEntity;

  @override
  late MoebooruClient client;

  @override
  List<SupportPage> getSupportPage() {
    return [
      SupportPage.POSTS,
      SupportPage.TAGS,
      SupportPage.ARTISTS,
      SupportPage.POOLS,
    ];
  }

  @override
  Future<List<BooruPost>> postList({
    required String tags,
    required int page,
    required int limit,
    CancelToken? cancelToken,
  }) async {
    final str = await client.postsList(
        tags: tags, limit: limit, page: page, cancelToken: cancelToken);
    return await compute(MoebooruPostParse.parse, str);
  }

  @override
  Future<List<BooruTag>> tagList({
    required String name,
    required int page,
    required int limit,
    CancelToken? cancelToken,
  }) async {
    final str = await client.tagsList(
      name: name,
      page: page,
      limit: limit,
      cancelToken: cancelToken,
    );
    return await compute(MoebooruTagParse.parse, str);
  }

  @override
  Dio get dio => client.dio;

  @override
  Future<List<BooruPool>> poolList({
    required String name,
    required int page,
    CancelToken? cancelToken,
  }) async {
    final str = await client.poolList(
      query: name,
      page: page,
      cancelToken: cancelToken,
    );
    return await compute(MoebooruPoolParser.parse, str);
  }

  @override
  Future<List<BooruArtist>> artistList({
    required String name,
    required int page,
  }) async {
    final str = await client.artistList(
      name: name,
      page: page,
    );
    return await compute(MoebooruArtistParse.parse, str);
  }

  @override
  Future<List<BooruComments>> comment({required String id}) async {
    final str = await client.commentsList(id);
    return await compute(MoebooruCommentParser.parse, str);
  }
}
