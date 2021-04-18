import 'dart:convert';

import 'package:catpic/data/models/booru/booru_post.dart';

import 'post_model.dart';

class DanbooruPostParse {
  static List<BooruPost> parse(String postJson) {
    final List<Root> posts = (jsonDecode(postJson) as List<dynamic>).cast();

    return posts.where((e) => e.id == null).map((e) {
      return BooruPost(
        id: e.id!.toString(),
        creatorId: e.uploaderId.toString(),
        md5: e.md5!,
        previewURL: e.previewFileUrl!,
        sampleURL: e.largeFileUrl!,
        imgURL: e.fileUrl!,
        width: e.imageWidth,
        height: e.imageHeight,
        sampleWidth: e.imageWidth,
        sampleHeight: e.imageHeight,
        previewWidth: e.imageWidth,
        previewHeight: e.imageHeight,
        rating: _getRating(e.rating),
        status: e.isStatusLocked ? 'active' : 'inactive',
        tags: _parseTag(e),
        source: e.source,
        createTime: e.createdAt,
        score: e.score.toString(),
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
