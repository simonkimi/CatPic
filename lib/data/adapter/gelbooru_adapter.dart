import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:catpic/data/parser/gelbooru/post_parser.dart';
import 'package:catpic/data/parser/gelbooru/tag_parser.dart';
import 'package:catpic/network/api/gelbooru/gelbooru_client.dart';
import 'package:dio/src/dio.dart';

import 'booru_adapter.dart';

class GelbooruAdapter implements BooruAdapter {
  GelbooruAdapter(this.websiteEntity) {
    client = GelbooruClient(websiteEntity);
  }

  final WebsiteEntity websiteEntity;

  GelbooruClient client;

  @override
  List<SupportPage> getSupportPage() {
    return [SupportPage.POSTS, SupportPage.TAGS];
  }

  @override
  Future<List<BooruPost>> postList({String tags, int page, int limit}) async {
    final str =
        await client.postsList(tags: tags, limit: limit, pid: page * limit);
    return GelbooruPostParser.parse(str);
  }

  @override
  Future<List<BooruTag>> tagList({String name, int page, int limit}) async {
    final str = await client.tagsList(limit: limit, names: name);
    return GelbooruTagParse.parse(str);
  }

  @override
  Dio get dio => client.dio;
}
