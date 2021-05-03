import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:xml/xml.dart';

class GelbooruTagParse {
  static List<BooruTag> parse(String tagXml) {
    final root = XmlDocument.parse(tagXml);
    final nodes = root.getElement('tags')?.children;
    return nodes?.where((e) => e.nodeType == XmlNodeType.ELEMENT).map((e) {
          return BooruTag(
              id: e.getAttributeNode('id')?.value ?? '',
              count:
                  int.tryParse(e.getAttributeNode('count')?.value ?? '') ?? 0,
              name: e.getAttributeNode('name')?.value ?? '',
              type: _getBooruTagType(e.getAttributeNode('type')?.value));
        }).toList() ??
        [];
  }

  static BooruTagType _getBooruTagType(String? type) {
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
