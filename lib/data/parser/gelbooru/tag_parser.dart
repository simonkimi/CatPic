import 'dart:convert';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:xml2json/xml2json.dart';

class GelbooruTagParse {
  static List<BooruTag> parse(String tagXml) {
    final xml2json = Xml2Json();
    xml2json.parse(tagXml);
    final Map<String, dynamic> json = jsonDecode(xml2json.toGData());

    if (!json.containsKey('tags'))
      return [];
    final Map<String, dynamic> tags = json['tags'];
    if (!tags.containsKey('tag'))
      return [];
    final List<dynamic> tag = tags['tag'];

    return tag.map((e) {
      return BooruTag(
          id: e['id'],
          count: int.parse(e['count']),
          name: e['name'],
          type: _getBooruTagType(e['type']));
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
