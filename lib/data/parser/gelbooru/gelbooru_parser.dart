import 'dart:convert';

import 'package:catpic/data/models/base/booru_post.dart';
import 'package:xml2json/xml2json.dart';

class GelbooruParse {
  static List<BooruPost> parsePostList(String postXml) {
    var xml2json = Xml2Json();
    xml2json.parse(postXml);
    Map<String, dynamic> json = jsonDecode(xml2json.toGData());
    if (!json.containsKey('posts')) return [];
    Map<String, dynamic> posts = json['posts'];
    if (!posts.containsKey('post')) return [];
    List<dynamic> post = posts['post'];
    return post.map((e) {
      return BooruPost(
        id: e['id'],
        md5: e['md5'],
        creatorId: e['creator_id'],
        imgURL: e['file_url'],
        previewURL: e['preview_url'],
        sampleURL: e['sample_url'],
        width: e['width'],
        height: e['height'],
        sampleWidth: e['sample_width'],
        sampleHeight: e['sample_height'],
        previewWidth: e['preview_width'],
        previewHeight: e['preview_height'],
        rating: _getRating(e['rating']),
        status: e['status'],
        tags: {'_': e['tags'].split(' ')},
        source: e['source'],
      );
    });
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
