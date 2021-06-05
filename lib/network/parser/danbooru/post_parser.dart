import 'dart:convert';

import 'package:catpic/data/models/booru/booru_post.dart';

import 'post_model.dart';

class DanbooruPostParse {
  static List<BooruPost> parse(String postJson) {
    final List<dynamic> posts = jsonDecode(postJson) as List<dynamic>;
    return posts.where((e) => e['id'] != null).map((e) {
      return parseSingle(e);
    }).toList();
  }

  static int _getRating(String name) {
    switch (name) {
      case 's':
        return PostRating.SAFE;
      case 'e':
        return PostRating.EXPLICIT;
      case 'q':
        return PostRating.QUESTIONABLE;
    }
    return PostRating.QUESTIONABLE;
  }

  static Map<String, List<String>> _parseTag(Root json) {
    final result = <String, List<String>>{};
    result['artist'] = json.tagStringArtist.split(' ');
    result['copyright'] = json.tagStringCopyright.split(' ');
    result['general'] = json.tagStringGeneral.split(' ');
    result['character'] = json.tagStringCharacter.split(' ');
    result['meta'] = json.tagStringMeta.split(' ');
    return result;
  }

  static BooruPost parseSingle(dynamic postJson) {
    late Root root;
    if (postJson is String) {
      root = Root.fromJson(jsonDecode(postJson) as Map<String, dynamic>);
    } else if (postJson is Map) {
      root = Root.fromJson(postJson.cast());
    }
    return BooruPost(
      id: root.id!.toString(),
      creatorId: root.uploaderId.toString(),
      md5: root.md5!,
      previewURL: root.previewFileUrl!,
      sampleURL: root.largeFileUrl!,
      imgURL: root.fileUrl!,
      width: root.imageWidth,
      height: root.imageHeight,
      sampleWidth: root.imageWidth,
      sampleHeight: root.imageHeight,
      previewWidth: root.imageWidth,
      previewHeight: root.imageHeight,
      rating: _getRating(root.rating),
      status: root.isStatusLocked ? 'active' : 'inactive',
      tags: _parseTag(root),
      source: root.source,
      createTime: root.createdAt,
      score: root.score.toString(),
    );
  }
}
