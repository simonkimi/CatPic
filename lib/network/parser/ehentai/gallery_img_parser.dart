import 'package:catpic/data/models/ehentai/gallery_img_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:tuple/tuple.dart';

class GalleryImgParser {
  static GalleryImgModel parse(String html) {
    final document = parser.parse(html).body;

    final meta = parseWidthHeightSize(document!);
    final width = int.parse(meta.item1);
    final height = int.parse(meta.item2);
    final imgSize = meta.item3;

    final imgUrl = document.querySelector('#img')?.attributes['src'] ?? '';

    final rawMeta = parseRawImg(document);
    final rawImgWidth = int.parse(rawMeta.item1);
    final rawImgHeight = int.parse(rawMeta.item2);
    final rawImgSize = rawMeta.item3;
    final rawImgUrl = rawMeta.item4;
    final sha =
        Uri.parse(document.querySelector('#i6 > a')?.attributes['href'] ?? '')
                .queryParameters['f_shash'] ??
            '';

    return GalleryImgModel(
      height: height,
      width: width,
      imgSize: imgSize,
      imgUrl: imgUrl,
      rawHeight: rawImgHeight,
      rawImgSize: rawImgSize,
      rawImgUrl: rawImgUrl,
      rawWidth: rawImgWidth,
      sha: sha,
    );
  }

  static Tuple3<String, String, String> parseWidthHeightSize(Element element) {
    final metaElement = element.querySelector('#i2')?.children[1];
    if (metaElement != null) {
      final re = RegExp(r'::\s(\d+)\sx\s(\d+)\s::\s([\d.]+\s.+)');
      final match = re.firstMatch(metaElement.text);
      if (match != null) {
        return Tuple3(match[1]!, match[2]!, match[3]!);
      }
      final re2 = RegExp(r'::\s(\d+)\sx\s(\d+)');
      final match2 = re2.firstMatch(metaElement.text);
      if (match2 != null) {
        return Tuple3(match2[1]!, match2[2]!, 'unknown');
      }
    }
    return const Tuple3('0', '0', 'unknown');
  }

  static Tuple4<String, String, String, String> parseRawImg(Element element) {
    final rawElement = element.querySelector('#i7 > a');
    if (rawElement != null) {
      final url = rawElement.attributes['href'];
      final re = RegExp(r'(\d+)\sx\s(\d+)\s([\d.]+\s.+)\s');
      final match = re.firstMatch(rawElement.text)!;
      return Tuple4(match[1]!, match[2]!, match[3]!, url!);
    }
    return const Tuple4('0', '0', '0', '');
  }
}
