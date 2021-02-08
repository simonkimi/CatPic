import 'dart:convert';
import 'package:catpic/data/models/booru/booru_tag.dart';

class MoebooruTagParse {
  static List<BooruTag> parse(String tagJson) {
    final List<dynamic> json = jsonDecode(tagJson);

    return json.map((e) {
      return BooruTag(
        id: e['id'].toString(),
        name: e['name'],
        count: e['count'],
        type: _getBooruTagType(e['type'].toString())
      );
    }).toList();
  }

  static BooruTagType _getBooruTagType(String type) {
    switch (type) {
      case '0':
        return BooruTagType.GENERAL;
      case '1':
        return BooruTagType.ARTIST;
      case '3':
        return BooruTagType.COPYRIGHT;
      case '4':
        return BooruTagType.CHARACTER;
      case '5':
        return BooruTagType.METADATA;
    }
    return BooruTagType.GENERAL;
  }
}
