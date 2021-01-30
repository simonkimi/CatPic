import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/data/models/base/booru_post.dart';
import 'package:catpic/data/parser/gelbooru/gelbooru_parser.dart';
import 'package:catpic/network/api/gelbooru/gelbooru_client.dart';

import '../booru_adapter.dart';

class GelbooruAdapter implements BooruAdapter {
  final WebsiteEntity websiteEntity;

  GelbooruClient client;

  GelbooruAdapter(this.websiteEntity) {
    client = GelbooruClient(websiteEntity);
  }

  @override
  List<SupportPage> getSupportPage() {
    return [SupportPage.POSTS];
  }

  @override
  Future<List<BooruPost>> postList({String tags, int page, int limit}) async {
    var str = await client.postsList(tags: tags, limit: limit, pid: page * limit);
    return GelbooruParse.parsePostList(str);
  }
}