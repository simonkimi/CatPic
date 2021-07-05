import 'dart:convert';

import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/network/parser/moebooru/post_parser.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/network/api/moebooru/moebooru_client.dart';
import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

import 'pool_model.dart';

class MoebooruPoolParser {
  static List<MoebooruPool> parse(String jsonStr) {
    final List<Map<String, dynamic>> json =
        (jsonDecode(jsonStr) as List<dynamic>).cast();
    return json
        .map((e) => MoebooruPool.fromRoot(PoolList.fromJson(e)))
        .toList();
  }

  static List<BooruPost> parseSingle(String jsonStr) {
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    final poolSingle = Pool.fromJson(json);
    return poolSingle.posts
        .map((e) => BooruPost(
              id: e.id.toString(),
              md5: e.md5,
              creatorId: e.creatorId.toString(),
              imgURL: e.fileUrl,
              previewURL: e.previewUrl,
              sampleURL: e.sampleUrl,
              width: e.width,
              height: e.height,
              sampleWidth: e.sampleWidth,
              sampleHeight: e.sampleHeight,
              previewWidth: e.previewWidth,
              previewHeight: e.previewHeight,
              rating: MoebooruPostParse.getRating(e.rating),
              status: e.status,
              tags: {'_': e.tags.split(' ')},
              source: e.source,
              createTime: e.createdAt,
              score: e.source,
            ))
        .toList();
  }
}

class MoebooruPool extends BooruPool {
  MoebooruPool({
    required String id,
    required String name,
    required String createAt,
    required String description,
    required int postCount,
  }) : super(
          id: id,
          name: name,
          createAt: createAt,
          description: description,
          postCount: postCount,
        );

  factory MoebooruPool.fromRoot(PoolList root) => MoebooruPool(
        id: root.id.toString(),
        postCount: root.postCount,
        description: root.description,
        createAt: root.createdAt,
        name: root.name,
      );

  List<BooruPost> posts = [];

  final getPostLock = Lock();

  @override
  Future<BooruPost> fromIndex(BaseClient client, int index) async {
    return posts[index];
  }

  @override
  Future<void> fetchPosts(BaseClient client) async {
    await getPostLock.synchronized(() async {
      if (posts.length != postCount) {
        final json = await (client as MoebooruClient).poolSingle(id);
        posts = await compute(MoebooruPoolParser.parseSingle, json);
      }
    });
  }
}
