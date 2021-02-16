import 'package:catpic/utils/misc_util.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:xml/xml.dart';

class GelbooruPostParser {
  static List<BooruPost> parse(String postXml) {
    final root = XmlDocument.parse(postXml);
    final nodes = root.children.last.children;
    return nodes.where((e) => e.nodeType == XmlNodeType.ELEMENT).map((e) {
      return BooruPost(
          id: e.getAttributeNode('id').value,
          md5: e.getAttributeNode('md5').value,
          creatorId: e.getAttributeNode('creator_id').value,
          imgURL: e.getAttributeNode('file_url').value,
          previewURL: e.getAttributeNode('preview_url').value,
          sampleURL: e.getAttributeNode('sample_url').value,
          width: int.parse(e.getAttributeNode('width').value),
          height: int.parse(e.getAttributeNode('height').value),
          sampleWidth: e.getAttributeNode('sample_width').value.toInt(),
          sampleHeight: e.getAttributeNode('sample_height').value.toInt(),
          previewWidth: e.getAttributeNode('preview_width').value.toInt(),
          previewHeight: e.getAttributeNode('preview_height').value.toInt(),
          rating: _getRating(e.getAttributeNode('rating').value),
          status: e.getAttributeNode('status').value,
          tags: {'_': e.getAttributeNode('tags').value.split(' ')},
          source: e.getAttributeNode('source').value,
          createTime: e.getAttributeNode('created_at').value,
          score: e.getAttributeNode('score').value);
    }).toList();
  }

  static PostRating _getRating(String name) {
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
}
