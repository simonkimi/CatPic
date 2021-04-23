import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:catpic/data/parser/danbooru/post_parser.dart';
import 'package:catpic/data/parser/danbooru/tag_parser.dart';
import 'package:catpic/network/api/danbooru/danbooru_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'booru_adapter.dart';

class DanbooruAdapter implements BooruAdapter {
  DanbooruAdapter(this.websiteEntity) {
    client = DanbooruClient(websiteEntity);
  }

  final WebsiteTableData websiteEntity;

  late DanbooruClient client;

  @override
  List<SupportPage> getSupportPage() {
    return [SupportPage.POSTS, SupportPage.TAGS];
  }

  @override
  Future<List<BooruPost>> postList(
      {required String tags,
      required int page,
      required int limit,
      Order order = Order.COUNT}) async {
    final str = await client.postsList(
      tags: tags,
      limit: limit,
      page: page,
    );

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
  Dio get dio => client.dio;
}
