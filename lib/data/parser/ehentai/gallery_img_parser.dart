import 'package:catpic/data/models/ehentai/gallery_img_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

class GalleryImgParser {
  final String html;

  GalleryImgParser(this.html);

  GalleryImgModel parse() {
    var document = parser.parse(html).body;

    var meta = parseWidthHeightSize(document);
    var width = int.parse(meta[0]);
    var height = int.parse(meta[1]);
    var imgSize = meta[2];

    var imgUrl = document.querySelector('#img')?.attributes['src'] ?? '';

    var rawMeta = parseRawImg(document);
    var rawImgWidth = int.parse(rawMeta[0]);
    var rawImgHeight = int.parse(rawMeta[1]);
    var rawImgSize = rawMeta[2];
    var rawImgUrl = rawMeta[3];



    return GalleryImgModel(
      height: height,
      width: width,
      imgSize: imgSize,
      imgUrl: imgUrl,
      rawHeight: rawImgHeight,
      rawImgSize: rawImgSize,
      rawImgUrl: rawImgUrl,
      rawWidth: rawImgWidth
    );
  }

  List<String> parseWidthHeightSize(Element element) {
    var metaElement = element.querySelector('#i2').children[1];
    var re = RegExp(r'::\s(\d+)\sx\s(\d+)\s::\s([\d.]+\s.+)');
    var match = re.firstMatch(metaElement.text);
    return [match[1], match[2], match[3]];
  }

  List<String> parseRawImg(Element element) {
    var rawElement = element.querySelector('#i7 > a');
    var url = rawElement.attributes['href'];
    var re = RegExp(r'(\d+)\sx\s(\d+)\s([\d.]+\s.+)\s');
    var match = re.firstMatch(rawElement.text);
    return [match[1], match[2], match[3], url];
  }
}
