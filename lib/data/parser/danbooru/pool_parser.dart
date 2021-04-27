import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/parser/danbooru/post_parser.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/network/api/danbooru/danbooru_client.dart';
import 'package:flutter/foundation.dart';

import 'pool_model.dart';

class DanbooruPoolParser extends BooruPool {
  DanbooruPoolParser({
    required String id,
    required String name,
    required String createAt,
    required String description,
    required int postCount,
    required this.postIndex,
  }) : super(
            id: id,
            name: name,
            createAt: createAt,
            description: description,
            postCount: postCount);

  factory DanbooruPoolParser.fromRoot(Root root) => DanbooruPoolParser(
      id: root.id.toString(),
      postCount: root.postCount,
      description: root.description,
      createAt: root.createdAt,
      name: root.name,
      postIndex: root.postIds);

  final List<int> postIndex;

  @override
  Future<BooruPost> fromIndex(BaseClient client, int index) async {
    final postId = postIndex[index];
    final postJson = await (client as DanbooruClient).postSingle(postId);
    return await compute(DanbooruPostParse.parseSingle, postJson);
  }
}
