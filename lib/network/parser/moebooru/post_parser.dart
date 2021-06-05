import 'dart:convert';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/network/parser/moebooru/post_model.dart';

class MoebooruPostParse {
  static List<BooruPost> parse(String postJson) {
    final List<Map<String, dynamic>> posts = jsonDecode(postJson)as List<Map<String, dynamic>>;

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
        rating: getRating(root.rating),
        status: root.status,
        tags: {'_': root.tags.split(' ')},
        source: root.source,
        score: root.score.toString(),
        createTime: parseTime(root.updatedAt ?? root.createdAt),
      );
    }).toList();
  }

  static int getRating(String? name) {
    switch (name) {
      case 's':
        return PostRating.SAFE;
      case 'e':
        return PostRating.EXPLICIT;
      case 'q':
      default:
        return PostRating.QUESTIONABLE;
    }
  }

  static String parseTime(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000).toString();
  }
}
