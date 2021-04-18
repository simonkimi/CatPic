import 'dart:convert';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/parser/moebooru/post_model.dart';

class MoebooruPostParse {
  static List<BooruPost> parse(String postJson) {
    final List<dynamic> posts = jsonDecode(postJson);

    return posts.map((e) {
      final root = Root.fromJson(e);
      return BooruPost(
        id: root.id.toString(),
        creatorId: root.creatorId.toString(),
        md5: root.md5,
        previewURL: root.previewUrl,
        sampleURL: root.sampleUrl,
        imgURL: root.fileUrl,
        width: root.width,
        height: root.height,
        sampleWidth: root.sampleWidth,
        sampleHeight: root.sampleHeight,
        previewWidth: root.previewWidth,
        previewHeight: root.previewHeight,
        rating: _getRating(root.rating),
        status: root.status,
        tags: {'_': root.tags.split(' ')},
        source: root.source,
        score: root.score.toString(),
        createTime: _parseTime(root.updatedAt),
      );
    }).toList();
  }

  static int _getRating(String? name) {
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

  static String _parseTime(int timeStamp) {
    return DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000).toString();
  }
}
