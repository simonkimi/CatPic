import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:catpic/utils/utils.dart';

class PreviewModel {
  PreviewModel({
    required this.maxPage,
    required this.resultCount,
    required this.items,
  });

  int maxPage;
  int resultCount;
  List<PreViewItemModel> items;
}

class PreviewParser {
  static PreviewModel parse(String previewHtml) {
    final document = parser.parse(previewHtml);

    final previewList = document
        .querySelectorAll('.itg > tbody > tr')
        .where((element) => element.querySelector('.gl1c') != null)
        .toList();

    final pageIndicator =
        document.querySelectorAll('.ptb td').reversed.toList();

    final maxPage =
        pageIndicator.isNotEmpty ? pageIndicator[1].text.toInt() : 0;

    final resultIndicator = document.querySelector('.ido .ip');

    final resultCount = resultIndicator != null
        ? resultIndicator.text.codeUnits
            .where((e) => e.equalBetween(48, 57))
            .map((e) => (e - 48).toString())
            .join('')
            .toInt()
        : 0;

    final items = previewList.map((element) {
      final title = element.querySelector('.glink')?.text ?? 'Error';
      final uploader =
          element.querySelector('.gl4c :first-child')?.text ?? 'Error';
      final pages = parsePages(element);
      final stars = parseStar(element);
      final tag = element.querySelector('.gl1c')?.text ?? '';
      final uploadTime = element.querySelector('[id^=posted]')?.text ?? '';

      final previewImg =
          parsePreview(element.querySelector('.glthumb :first-child img'));

      final language = parseLanguage(element);

      final imgSize = parseImg(element);
      final targetUrl =
          element.querySelector('.gl3c a')?.attributes['href'] ?? '';
      final gidAndgtoken = parseToken(targetUrl);

      final keyTags = parseTag(element);

      return PreViewItemModel(
          gid: gidAndgtoken[0],
          gtoken: gidAndgtoken[1],
          pages: pages,
          previewImg: previewImg,
          stars: stars,
          tag: fromEhTag(tag),
          targetUrl: targetUrl,
          title: title,
          uploader: uploader,
          uploadTime: uploadTime,
          language: language,
          keyTags: keyTags,
          previewWidth: imgSize[0],
          previewHeight: imgSize[1]);
    }).toList();
    return PreviewModel(
      items: items,
      maxPage: maxPage,
      resultCount: resultCount,
    );
  }

  static String parsePreview(Element? element) {
    if (element?.attributes.containsKey('data-src') ?? false)
      return element!.attributes['data-src']!;
    else if (element?.attributes.containsKey('src') ?? false)
      return element!.attributes['src']!;
    return '';
  }

  /// 解析gid和gtoken
  static List<String> parseToken(String targetUrl) {
    if (targetUrl.isNotEmpty) {
      final re = RegExp(r'/g/(\w+)/(\w+)/');
      final match = re.firstMatch(targetUrl)!;
      return [match[1]!, match[2]!];
    }
    return ['', ''];
  }

  /// 解析有多少面
  static int parsePages(Element e) {
    final pageElement = e.querySelectorAll('.gl4c div');
    if (pageElement.length == 2) {
      return int.parse(pageElement[1].text.split(' ')[0]);
    }
    return 0;
  }

  /// 解析几颗星
  static double parseStar(Element e) {
    final starElement = e.querySelector('.ir');
    if (starElement != null) {
      final re = RegExp(r':-?(\d+)px\s-?(\d+)px');
      final style = starElement.attributes['style']!;
      final starData = re.firstMatch(style);
      final num1 = int.tryParse(starData?[1] ?? '') ?? 0;
      final num2 = int.tryParse(starData?[2] ?? '') ?? 1;
      return 5 - (num1 / 16) - (num2 > 10 ? 0.5 : 0);
    }
    return 0;
  }

  static List<PreviewTag> parseTag(Element element) {
    final tagElements = element.querySelectorAll('.gt');
    return tagElements.map((e) {
      final tag = e.text;
      var color = 0;
      if (e.attributes.containsKey('style')) {
        final style = e.attributes['style']!;
        final reg = RegExp(r',#(\w{6})\)');
        final match = reg.firstMatch(style);
        color = int.parse(match![1]!, radix: 16);
      }
      return PreviewTag(
        tag: tag,
        color: color,
      );
    }).toList();
  }

  /// 解析语言
  static String parseLanguage(Element element) {
    final tagElement = element.querySelectorAll('.gt');
    for (final e in tagElement) {
      if (e.attributes['title']?.contains('language') ?? false) {
        return e.attributes['title']?.substring('language:'.length) ?? '';
      }
    }
    return '';
  }

  /// 解析预览图长宽
  static List<int> parseImg(Element e) {
    final imgElement = e.querySelector('.glthumb img');
    if (imgElement != null) {
      final styleText = imgElement.attributes['style'];
      final re = RegExp(r'height:(\d+?)px;width:(\d+?)px');
      final reM = re.firstMatch(styleText!)!;
      return [int.parse(reM[1]!), int.parse(reM[2]!)];
    }
    return [0, 0];
  }
}
