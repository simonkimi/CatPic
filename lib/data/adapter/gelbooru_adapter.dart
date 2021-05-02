import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/booru_artist.dart';
import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:catpic/data/parser/gelbooru/post_parser.dart';
import 'package:catpic/data/parser/gelbooru/tag_parser.dart';
import 'package:catpic/network/api/gelbooru/gelbooru_client.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/dio.dart';
import 'package:flutter/foundation.dart';

import 'booru_adapter.dart';

class GelbooruAdapter implements BooruAdapter {
  GelbooruAdapter(this.websiteEntity) {
    client = GelbooruClient(websiteEntity);
  }

  final WebsiteTableData websiteEntity;

  @override
  late GelbooruClient client;

  @override
  List<SupportPage> getSupportPage() {
    return [SupportPage.POSTS, SupportPage.TAGS];
  }

  @override
  Future<List<BooruPost>> postList({
    required String tags,
    required int page,
    required int limit,
    CancelToken? cancelToken,
  }) async {
    final str = await client.postsList(
        tags: tags, limit: limit, pid: page, cancelToken: cancelToken);
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
  Future<List<BooruArtist>> artistList({
    required String name,
    required int page,
  }) {
    throw UnsupportedError('Gelbooru not support Artist!');
  }
}
