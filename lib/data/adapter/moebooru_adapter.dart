import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:catpic/data/parser/moebooru/post_parser.dart';
import 'package:catpic/data/parser/moebooru/tag_parser.dart';
import 'package:catpic/network/api/moebooru/moebooru_client.dart';

import 'booru_adapter.dart';

class MoebooruAdapter implements BooruAdapter {
  final WebsiteEntity websiteEntity;

  MoebooruClient client;

  MoebooruAdapter(this.websiteEntity) {
    client = MoebooruClient(websiteEntity);
  }

  @override
  List<SupportPage> getSupportPage() {
    return [SupportPage.POSTS, SupportPage.TAGS];
  }

  @override
  Future<List<BooruPost>> postList({String tags, int page, int limit}) async {
    var str = await client.postsList(tags: tags, limit: limit, page: page);
    return MoebooruPostParse.parse(str);
  }

  @override
  Future<List<BooruTag>> tagList({String name, int page, int limit}) async {
    var str = await client.tagsList(name: name, page: page, limit: limit);
    return MoebooruTagParse.parse(str);
  }
}
