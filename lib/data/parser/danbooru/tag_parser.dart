import 'dart:convert';

import 'package:catpic/data/models/booru/booru_tag.dart';
import 'tag_model.dart';

class DanbooruTagParser {
  static List<BooruTag> parse(String tagJson) {
    print(tagJson);
    final List<dynamic> tags = jsonDecode(tagJson);
    return tags
        .map((e) => Root.fromJson(e))
        .map((e) => BooruTag(
              id: e.id.toString(),
              name: e.name,
              type: _getBooruTagType(e.category),
              count: e.postCount,
            ))
        .toList();
  }

  static BooruTagType _getBooruTagType(int? type) {
    switch (type) {
      case 0:
        return BooruTagType.GENERAL;
      case 1:
        return BooruTagType.ARTIST;
      case 3:
        return BooruTagType.COPYRIGHT;
      case 4:
        return BooruTagType.CHARACTER;
      case 5:
        return BooruTagType.METADATA;
    }
    return BooruTagType.GENERAL;
  }
}
