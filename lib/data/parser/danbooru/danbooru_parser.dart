import 'dart:convert';
import 'package:catpic/data/models/booru/booru_post.dart';

class DanbooruParse {
  static List<BooruPost> parsePostList(String postJson) {
    final List<dynamic> posts = jsonDecode(postJson);
    return posts.map((e) {
      return BooruPost(
        id: e['id'],
        creatorId: e['uploader_id'],
        md5: e['md5'],
        previewURL: e['preview_file_url'],
        sampleURL: e['large_file_url'],
        imgURL: e['file_url'],
        width: e['image_width'],
        height: e['image_height'],
        sampleWidth: e['image_width'],
        sampleHeight: e['image_height'],
        previewWidth: e['image_width'],
        previewHeight: e['image_height'],
        rating: _getRating(e['rating']),
        status: e['is_status_locked'] ? 'active' : 'inactive',
        tags: _parseTag(e),
        source: e['source'],
        // TODO createTime score未解析
        createTime: '',
        score: '',
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

  static Map<String, List<String>> _parseTag(Map<String, dynamic> json) {
    final result = <String, List<String>>{};
    json.forEach((key, value) {
      if (key.startsWith('tag_string_')) {
        final k = key.substring('tag_string_'.length, key.length);
        result[k] = value.split(' ');
      }
    });
    return result;
  }
}
