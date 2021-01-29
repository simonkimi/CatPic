import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

class PreviewParser {
  final String previewHtml;

  PreviewParser(this.previewHtml);

  List<PreViewModel> parse() {
    var document = parser.parse(previewHtml);

    var previewList = document
        .querySelectorAll('.itg > tbody > tr')
        .where((element) => element.querySelector('.gl1c') != null)
        .toList();

    return previewList.map((element) {
      var title = element.querySelector('.glink')?.text ?? 'Error';
      var uploader =
          element.querySelector('.gl4c :first-child')?.text ?? 'Error';
      var pages = parsePages(element);
      var stars = parseStar(element);
      var tag = element.querySelector('.gl1c')?.text ?? '';
      var uploadTime = element.querySelector('.glnew')?.text ?? '';
      var previewImg =
          element.querySelector('.glthumb img')?.attributes['src'] ?? '';
      var language = parseLanguage(element);

      var imgSize = parseImg(element);
      var targetUrl =
          element.querySelector('.gl3c a')?.attributes['href'] ?? '';
      var gidAndgtoken = parseToken(targetUrl);

      var keyTags = parseTag(element);

      print(keyTags);

      return PreViewModel(
          gid: gidAndgtoken[0],
          gtoken: gidAndgtoken[1],
          pages: pages,
          previewImg: previewImg,
          stars: stars,
          tag: tag,
          targetUrl: targetUrl,
          title: title,
          uploader: uploader,
          uploadTime: uploadTime,
          language: language,
          keyTags: keyTags,
          previewWidth: imgSize[0],
          previewHeight: imgSize[1]);
    }).toList();
  }

  /// 解析gid和gtoken
  List<String> parseToken(String targetUrl) {
    if (targetUrl.isNotEmpty) {
      var re = RegExp(r'/g/(\w+)/(\w+)/');
      var match = re.firstMatch(targetUrl);
      print('${match[1]}, ${match[2]}');
      return [match[1], match[2]];
    }
    return ['', ''];
  }

  /// 解析有多少面
  int parsePages(Element e) {
    var pageElement = e.querySelectorAll('.gl4c div');
    if (pageElement.length == 2) {
      return int.parse(pageElement[1].text.split(' ')[0]);
    }
    return 0;
  }

  /// 解析几颗星
  double parseStar(Element e) {
    var starElement = e.querySelector('.ir');
    if (starElement != null) {
      var re = RegExp(r':-?(\d+)px\s-?(\d+)px');
      var style = starElement.attributes['style'];
      var starData = re.firstMatch(style);
      var num1 = int.parse(starData[1]);
      var num2 = int.parse(starData[2]);
      return 5 - (num1 / 16) - (num2 > 10 ? 0.5 : 0);
    }
    return 0;
  }

  List<PreviewTag> parseTag(Element element) {
    var tagElements = element.querySelectorAll('.gt');
    return tagElements.map((e) {
      var tag = e.text;
      var color = 0;
      if (e.attributes.containsKey('style')) {
        var style = e.attributes['style'];
        var reg = RegExp(r',#(\w{6})\)');
        var match = reg.firstMatch(style);
        color = int.parse(match[1], radix: 16);
      }
      return PreviewTag(
          tag: tag,
          color: color
      );
    }).toList();
  }

  /// 解析语言
  String parseLanguage(Element element) {
    var tagElement = element.querySelectorAll('.gt');
    for (var e in tagElement) {
      if (e.attributes['title']?.contains('language') ?? false) {
        return e.attributes['title']?.substring('language:'.length);
      }
    }
    return '';
  }

  /// 解析预览图长宽
  List<int> parseImg(Element e) {
    var imgElement = e.querySelector('.glthumb img');
    if (imgElement != null) {
      var styleText = imgElement.attributes['style'];
      var re = RegExp(r'height:(\d+?)px;width:(\d+?)px');
      var reM = re.firstMatch(styleText);
      return [int.parse(reM[1]), int.parse(reM[2])];
    }
    return [0, 0];
  }
}
