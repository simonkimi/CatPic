import 'package:catpic/data/models/ehentai/gallery_img_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

class GalleryImgParser {
  GalleryImgParser(this.html);

  final String html;

  GalleryImgModel parse() {
    final document = parser.parse(html).body;

    final meta = parseWidthHeightSize(document!);
    final width = int.parse(meta[0]);
    final height = int.parse(meta[1]);
    final imgSize = meta[2];

    final imgUrl = document.querySelector('#img')?.attributes['src'] ?? '';

    final rawMeta = parseRawImg(document);
    final rawImgWidth = int.parse(rawMeta[0]);
    final rawImgHeight = int.parse(rawMeta[1]);
    final rawImgSize = rawMeta[2];
    final rawImgUrl = rawMeta[3];

    return GalleryImgModel(
        height: height,
        width: width,
        imgSize: imgSize,
        imgUrl: imgUrl,
        rawHeight: rawImgHeight,
        rawImgSize: rawImgSize,
        rawImgUrl: rawImgUrl,
        rawWidth: rawImgWidth);
  }

  List<String> parseWidthHeightSize(Element element) {
    final metaElement = element.querySelector('#i2')?.children[1];
    if (metaElement != null) {
      final re = RegExp(r'::\s(\d+)\sx\s(\d+)\s::\s([\d.]+\s.+)');
      final match = re.firstMatch(metaElement.text)!;
      return [match[1]!, match[2]!, match[3]!];
    }
    return [];
  }

  List<String> parseRawImg(Element element) {
    final rawElement = element.querySelector('#i7 > a');
    if (rawElement != null) {
      final url = rawElement.attributes['href'];
      final re = RegExp(r'(\d+)\sx\s(\d+)\s([\d.]+\s.+)\s');
      final match = re.firstMatch(rawElement.text)!;
      return [match[1]!, match[2]!, match[3]!, url!];
    }
    return [];
  }
}
