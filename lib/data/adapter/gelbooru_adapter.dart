
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:catpic/data/parser/gelbooru/post_parser.dart';
import 'package:catpic/data/parser/gelbooru/tag_parser.dart';
import 'package:catpic/network/api/gelbooru/gelbooru_client.dart';
import 'package:dio/src/dio.dart';
import 'package:flutter/foundation.dart';

import 'booru_adapter.dart';

class GelbooruAdapter implements BooruAdapter {
  GelbooruAdapter(this.websiteEntity) {
    client = GelbooruClient(websiteEntity);
  }

  final WebsiteEntity websiteEntity;

  late GelbooruClient client;

  @override
  List<SupportPage> getSupportPage() {
    return [SupportPage.POSTS, SupportPage.TAGS];
  }

  @override
  Future<List<BooruPost>> postList(
      {required String tags, required int page, required int limit}) async {
    final str = await client.postsList(tags: tags, limit: limit, pid: page);

    return await compute(GelbooruPostParser.parse, str);
  }

  @override
  Future<List<BooruTag>> tagList(
      {required String name, required int page, required int limit}) async {
    final str = await client.tagsList(limit: limit, names: name);
    return await compute(GelbooruTagParse.parse, str);
  }

  @override
  Dio get dio => client.dio;
}
