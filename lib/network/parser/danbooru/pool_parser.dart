import 'dart:convert';
import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/network/parser/danbooru/post_parser.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/network/api/danbooru/danbooru_client.dart';
import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

import 'pool_model.dart';

class DanbooruPoolParser {
  static List<DanbooruPool> parse(String jsonStr) {
    final List<Map<String, dynamic>> json = jsonDecode(jsonStr) as List<Map<String, dynamic>>;

    return json
        .map((e) => DanbooruPool.fromRoot(PoolList.fromJson(e)))
        .toList();
  }
}

class DanbooruPool extends BooruPool {
  DanbooruPool({
    required String id,
    required String name,
    required String createAt,
    required String description,
    required int postCount,
    required this.posts,
  }) : super(
          id: id,
          name: name,
          createAt: createAt,
          description: description,
          postCount: postCount,
        );

  factory DanbooruPool.fromRoot(PoolList root) => DanbooruPool(
        id: root.id.toString(),
        postCount: root.postCount,
        description: root.description,
        createAt: root.createdAt,
        name: root.name,
        posts: root.postIds,
      );

  final List<int> posts;

  late final List<BooruPost?> postList = List.filled(postCount, null);
  late final List<Lock?> postLock = List.filled(postCount, null);

  @override
  Future<BooruPost> fromIndex(BaseClient client, int index) async {
    if (postList[index] != null) return postList[index]!;

    return await (postLock[index] ??= Lock()).synchronized(() async {
      final postId = posts[index];
      final postJson = await (client as DanbooruClient).postSingle(postId);
      final booruPost = await compute(DanbooruPostParse.parseSingle, postJson);
      postList[index] = booruPost;
      return booruPost;
    });
  }

  @override
  Future<void> fetchPosts(BaseClient client) async {
    return;
  }
}
