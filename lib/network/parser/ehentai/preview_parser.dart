import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/utils/utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:catpic/data/models/gen/eh_preview.pb.dart';

class RequireLoginException implements Exception {
  @override
  String toString() => '需要登录';
}

class PreviewModel {
  PreviewModel({
    required this.items,
    this.exception,
  });

  List<PreViewItemModel> items;

  Object? exception;
}

class PreviewParser {
  static PreviewModel parse(String previewHtml) {
    final document = parser.parse(previewHtml).body!;
    if (document.querySelector('#iw') != null ||
        document.querySelector('[name=ipb_login_form]') != null) {
      return PreviewModel(
        items: [],
        exception: RequireLoginException(),
      );
    }

    final view = document.querySelector('option[selected=selected]')?.text;
    switch (view) {
      case 'Minimal':
        return parseMinimal(document);
      case 'Minimal+':
        return parseMinimalPlus(document);
      case 'Extended':
        return parseExtended(document);
      case 'Thumbnail':
        return parseThumbnail(document);
      case 'Compact':
      default:
        return parseCompact(document);
    }
  }

  static PreviewModel parseMinimal(Element document) {
    final previewList = document
        .querySelectorAll('.itg > tbody > tr')
        .where((element) => element.querySelector('.glcat') != null)
        .toList();

    final items = previewList.map((element) {
      final title = element.querySelector('.glink')?.text ?? 'Error';
      final uploader = element.querySelector('.gl5m a')?.text ?? 'Error';
      final stars = parseStar(element);
      final tag = element.querySelector('.cs')?.text ?? '';
      final uploadTime = element.querySelector('[id^=posted]')?.text ?? '';
      final previewImg = parsePreview(element.querySelector('.glthumb img'));
      final imgSize = parseImg(element);
      final gidAndgtoken = parseToken(element);
      final pages = parsePages(element);
      return PreViewItemModel(
        gid: gidAndgtoken[0],
        gtoken: gidAndgtoken[1],
        pages: pages,
        previewImg: previewImg,
        stars: stars,
        tag: fromEhTag(tag),
        title: title,
        uploader: uploader,
        uploadTime: uploadTime,
        language: '',
        keyTags: [],
        previewWidth: imgSize[0],
        previewHeight: imgSize[1],
      );
    }).toList();
    return PreviewModel(
      items: items,
    );
  }

  static PreviewModel parseMinimalPlus(Element document) {
    final previewList = document
        .querySelectorAll('.itg > tbody > tr')
        .where((element) => element.querySelector('.gl1m') != null)
        .toList();

    final items = previewList.map((element) {
      final title = element.querySelector('.glink')?.text ?? 'Error';
      final uploader = element.querySelector('.gl5m a')?.text ?? 'Error';
      final stars = parseStar(element);
      final tag = element.querySelector('.cn')?.text ?? '';
      final uploadTime = element.querySelector('[id^=posted]')?.text ?? '';
      final previewImg = parsePreview(element.querySelector('.glthumb img'));
      final imgSize = parseImg(element);
      final gidAndgtoken = parseToken(element);
      final keyTags = parseTag(element);
      final pages = parsePages(element);
      return PreViewItemModel(
        gid: gidAndgtoken[0],
        gtoken: gidAndgtoken[1],
        pages: pages,
        previewImg: previewImg,
        stars: stars,
        tag: fromEhTag(tag),
        title: title,
        uploader: uploader,
        uploadTime: uploadTime,
        language: '',
        keyTags: keyTags,
        previewWidth: imgSize[0],
        previewHeight: imgSize[1],
      );
    }).toList();
    return PreviewModel(
      items: items,
    );
  }

  static PreviewModel parseThumbnail(Element document) {
    final previewList = document.querySelectorAll('.gl1t').toList();
    final items = previewList.map((element) {
      final title = element.querySelector('.glink')?.text ?? 'Error';
      final pages = parsePages(element);
      final stars = parseStar(element);
      final tag = element.querySelector('.cs')?.text ?? '';
      final uploadTime = element.querySelector('[id^=posted]')?.text ?? '';
      final keyTags = parseTag(element);
      final previewImg = parsePreview(element.querySelector('.gl3t img'));
      final gidAndgtoken = parseToken(element);
      final imgSize = parseImg(element);
      return PreViewItemModel(
        gid: gidAndgtoken[0],
        gtoken: gidAndgtoken[1],
        pages: pages,
        previewImg: previewImg,
        stars: stars,
        tag: fromEhTag(tag),
        title: title,
        uploader: '',
        uploadTime: uploadTime,
        language: '',
        keyTags: keyTags,
        previewWidth: imgSize[0],
        previewHeight: imgSize[1],
      );
    }).toList();
    return PreviewModel(
      items: items,
    );
  }

  static PreviewModel parseExtended(Element document) {
    final previewList = document
        .querySelectorAll('.itg > tbody > tr')
        .where((element) => element.querySelector('.gl1e') != null)
        .toList();

    final items = previewList.map((element) {
      final title = element.querySelector('.glink')?.text ?? 'Error';
      final uploader = element.querySelector('.gl3e a')?.text ?? 'Error';
      final pages = element
              .querySelector('.gl3e')
              ?.children[4]
              .text
              .split(' ')[0]
              .toInt() ??
          0;
      final stars = parseStar(element);
      final tag = element.querySelector('.gl1c')?.text ?? '';
      final uploadTime = element.querySelector('[id^=posted]')?.text ?? '';
      final previewImg = parsePreview(element.querySelector('.gl1e img'));
      final language = parseLanguage(element);
      final imgSize = parseImg(element);
      final gidAndgtoken = parseToken(element);
      final keyTags = parseTag(element);

      return PreViewItemModel(
        gid: gidAndgtoken[0],
        gtoken: gidAndgtoken[1],
        pages: pages,
        previewImg: previewImg,
        stars: stars,
        tag: fromEhTag(tag),
        title: title,
        uploader: uploader,
        uploadTime: uploadTime,
        language: language,
        keyTags: keyTags,
        previewWidth: imgSize[0],
        previewHeight: imgSize[1],
      );
    }).toList();
    return PreviewModel(
      items: items,
    );
  }

  static PreviewModel parseCompact(Element document) {
    final previewList = document
        .querySelectorAll('.itg > tbody > tr')
        .where((element) => element.querySelector('.gl1c') != null)
        .toList();

    final items = previewList.map((element) {
      final title = element.querySelector('.glink')?.text ?? 'Error';
      final uploader =
          element.querySelector('.gl4c :first-child')?.text ?? 'Error';
      final pages = parsePages(element);
      final stars = parseStar(element);
      final tag = element.querySelector('.gl1c')?.text ?? '';
      final uploadTime = element.querySelector('[id^=posted]')?.text ?? '';
      final previewImg = parsePreview(element.querySelector('.glthumb img'));
      final language = parseLanguage(element);
      final imgSize = parseImg(element);
      final gidAndgtoken = parseToken(element);
      final keyTags = parseTag(element);

      return PreViewItemModel(
        gid: gidAndgtoken[0],
        gtoken: gidAndgtoken[1],
        pages: pages,
        previewImg: previewImg,
        stars: stars,
        tag: fromEhTag(tag),
        title: title,
        uploader: uploader,
        uploadTime: uploadTime,
        language: language,
        keyTags: keyTags,
        previewWidth: imgSize[0],
        previewHeight: imgSize[1],
      );
    }).toList();
    return PreviewModel(
      items: items,
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
  static List<String> parseToken(Element document) {
    final targetUrl = document.querySelector('.glname a')?.attributes['href'] ??
        document.querySelector('.gl3t a')?.attributes['href'] ??
        document.querySelector('.gl1e a')?.attributes['href'] ??
        '';
    if (targetUrl.isNotEmpty) {
      final re = RegExp(r'/g/(\w+)/(\w+)/');
      final match = re.firstMatch(targetUrl)!;
      return [match[1]!, match[2]!];
    }
    return ['', ''];
  }

  /// 解析有多少面
  static int parsePages(Element e) {
    final pageBrotherElement = e.querySelector('.ir');
    final pageElement = pageBrotherElement?.parent?.children[1];
    if (pageElement != null) {
      return int.parse(pageElement.text.split(' ')[0]);
    }
    return 0;
  }

  /// 解析几颗星
  static double parseStar(Element e) {
    final starElement = e.querySelectorAll('.ir');
    if (starElement.isNotEmpty) {
      final star = starElement[0];
      final re = RegExp(r':-?(\d+)px\s-?(\d+)px');
      final style = star.attributes['style']!;
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
    final imgElement = e.querySelector('.glthumb img') ??
        e.querySelector('.gl3t img') ??
        e.querySelector('.gl1e img');
    if (imgElement != null) {
      final styleText = imgElement.attributes['style'];
      final re = RegExp(r'height:(\d+?)px;width:(\d+?)px');
      final reM = re.firstMatch(styleText!)!;
      return [int.parse(reM[1]!), int.parse(reM[2]!)];
    }
    return [0, 0];
  }
}
