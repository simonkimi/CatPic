import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/utils/utils.dart';
import 'package:xml/xml.dart';

class GelbooruPostParser {
  static List<BooruPost> parse(String postXml) {
    final root = XmlDocument.parse(postXml);
    final nodes = root.children.last.children;
    return nodes.where((e) => e.nodeType == XmlNodeType.ELEMENT).map((e) {
      return BooruPost(
          id: e.getAttributeNode('id')?.value ?? '',
          md5: e.getAttributeNode('md5')?.value ?? '',
          creatorId: e.getAttributeNode('creator_id')?.value ?? '',
          imgURL: e.getAttributeNode('file_url')?.value ?? '',
          previewURL: e.getAttributeNode('preview_url')?.value ?? '',
          sampleURL: e.getAttributeNode('sample_url')?.value ?? '',
          width: int.tryParse(e.getAttributeNode('width')?.value ?? '') ?? 0,
          height: int.tryParse(e.getAttributeNode('height')?.value ?? '') ?? 0,
          sampleWidth: e.getAttributeNode('sample_width')?.value.toInt() ?? 0,
          sampleHeight: e.getAttributeNode('sample_height')?.value.toInt() ?? 0,
          previewWidth: e.getAttributeNode('preview_width')?.value.toInt() ?? 0,
          previewHeight:
              e.getAttributeNode('preview_height')?.value.toInt() ?? 0,
          rating: _getRating(e.getAttributeNode('rating')?.value),
          status: e.getAttributeNode('status')?.value ?? '',
          tags: {'_': e.getAttributeNode('tags')?.value.split(' ') ?? []},
          source: e.getAttributeNode('source')?.value ?? '',
          createTime: e.getAttributeNode('created_at')?.value ?? '',
          score: e.getAttributeNode('score')?.value ?? '');
    }).toList();
  }

  static int _getRating(String? name) {
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
