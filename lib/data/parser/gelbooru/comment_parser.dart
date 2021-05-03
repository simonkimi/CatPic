import 'package:xml/xml.dart';
import 'package:catpic/data/models/booru/booru_comment.dart';

class GelbooruCommentParser {
  static List<BooruComments> parse(String str) {
    final root = XmlDocument.parse(str);

    final nodes = root.children.last.children;
    return nodes.where((e) => e.nodeType == XmlNodeType.ELEMENT).map((e) {
      return BooruComments(
        id: e.getAttributeNode('id')?.value ?? '',
        body: e.getAttributeNode('body')?.value ?? '',
        createAt: e.getAttributeNode('created_at')?.value ?? '',
        creator: e.getAttributeNode('creator')?.value ?? '',
      );
    }).toList();
  }
}
