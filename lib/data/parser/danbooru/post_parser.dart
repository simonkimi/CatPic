import 'dart:convert';

import 'package:catpic/data/models/booru/booru_post.dart';

import 'post_model.dart';

class DanbooruPostParse {
  static List<BooruPost> parse(String postJson) {
    final List<dynamic> posts = jsonDecode(postJson);
    return posts.where((e) => e.id != null).map((e) {
      final root = Root.fromJson(e);
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
        tags: _parseTag(e),
        source: root.source,
        createTime: root.createdAt,
        score: root.score.toString(),
      );
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
}
