import 'dart:convert';
import 'package:catpic/data/models/booru/booru_post.dart';

class MoebooruPostParse {
  static List<BooruPost> parse(String postJson) {
    List<dynamic> posts = jsonDecode(postJson);
    return posts.map((e) {
      return BooruPost(
        id: e['id'],
        creatorId: e['creator_id'],
        md5: e['md5'],
        previewURL: e['preview_url'],
        sampleURL: e['sample_url'],
        imgURL: e['file_url'],
        width: e['width'],
        height: e['height'],
        sampleWidth: e['sample_width'],
        sampleHeight: e['sample_height'],
        previewWidth: e['preview_width'],
        previewHeight: e['preview_height'],
        rating: _getRating(e['rating']),
        status: e['is_status_locked'] ? 'active' : 'inactive',
        tags: {'_': e['tags'].split(' ')},
        source: e['source']
      );
    }).toList();
  }

  static PostRating _getRating(String name) {
    switch (name) {
      case 's':
        return PostRating.SAFE;
        break;
      case 'e':
        return PostRating.EXPLICIT;
        break;
      case 'q':
        return PostRating.QUESTIONABLE;
        break;
    }
    return PostRating.QUESTIONABLE;
  }
}
