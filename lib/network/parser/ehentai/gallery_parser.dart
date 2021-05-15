import 'package:catpic/data/models/ehentai/gallery_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:catpic/utils/utils.dart';

class GalleryParser {
  static GalleryModel parse(String galleryHtml) {
    final document = parser.parse(galleryHtml).body!;
    final tags = parseTags(document);
    final favcount = int.tryParse(document
                .querySelector('#favcount')
                ?.text
                .replaceAll(' times', '') ??
            '') ??
        0;
    final fileSize = document
        .querySelectorAll('#gdd > table > tbody > tr')[4]
        .children[1]
        .text;

    final previewImages = parsePreview(document);
    final maxPageIndex = parseMaxPage(document);
    final comments = parseComment(document);
    final title = document.querySelector('#gn')!.text;

    final visible = document
            .querySelectorAll('#gdd > table > tbody > tr')[2]
            .children[1]
            .text ==
        'Yes';

    final parent = parseParent(document);

    final imageCount = document
        .querySelectorAll('#gdd > table > tbody > tr')[5]
        .children[1]
        .text
        .replaceAll(' pages', '')
        .toInt();

    final language = document
        .querySelectorAll('#gdd > table > tbody > tr')[3]
        .children[1]
        .text
        .replaceAll(' ', '');

    return GalleryModel(
      gid: '',
      token: '',
      title: title,
      tags: tags,
      favorited: favcount,
      fileSize: fileSize,
      previewImages: previewImages,
      maxPageIndex: maxPageIndex,
      comments: comments,
      parent: parent,
      visible: visible,
      imageCount: imageCount,
      language: language,
    );
  }

  static GalleryBase? parseParent(Element e) {
    final parentElement = e
        .querySelectorAll('#gdd > table > tbody > tr')[1]
        .querySelector('.gdt2');
    if (parentElement?.text == 'None') return null;
    final href =
        parentElement!.querySelector('a')!.attributes['href']!.split('/');
    return GalleryBase(
      gid: href.lastAt(3),
      token: href.lastAt(2),
    );
  }

  static List<TagModels> parseTags(Element e) {
    final tagElements = e.querySelectorAll('#taglist > table > tbody > tr');
    return tagElements.map((e) {
      var title = e.children[0].text;
      final tags = e.children[1].children.map((e) => e.text).toList();
      title = title.substring(0, title.length - 1);
      return TagModels(key: title, value: tags);
    }).toList();
  }

  /// 解析预览 [0]: 预览URL, [1]: 指向地址
  static List<PreviewImage> parsePreview(Element element) {
    final imgContainer = element.querySelectorAll('.gdtm');
    return imgContainer.map((e) {
      final style = e.children[0].attributes['style'];
      final re = RegExp(
          r'height:(\d+)px;\sbackground:transparent\surl\((\S+)\)\s-?(\d+)px');
      final data = re.firstMatch(style!)!;

      final aElement = e.querySelector('a')!;
      return PreviewImage(
        height: int.tryParse(data[1] ?? '') ?? 0,
        image: data[2]!,
        positioning: int.parse(data[3]!),
        target: aElement.attributes['href']!,
      );
    }).toList();
  }

  /// 解析最大面数
  static int parseMaxPage(Element element) {
    final bottomBarElements =
        element.querySelectorAll('.ptb > tbody > tr > td');
    final ele = bottomBarElements[bottomBarElements.length - 2];
    return int.parse(ele.text);
  }

  static List<CommentModel> parseComment(Element element) {
    final comments = element.querySelectorAll('.c1');

    return comments.map((e) {
      final uploader = e.querySelector('.c3 > a')?.text ?? '';
      final re = RegExp(r'on\s([\w\s,:]+)\sby');
      final uploadTimeText = e.querySelector('.c3')!.text;
      final match = re.firstMatch(uploadTimeText)!;
      var comment =
          e.querySelector('.c6')?.innerHtml.replaceAll('<br>', '\n') ?? '';
      final commentDocument = parser.parse(comment);
      comment = commentDocument.body!.text;
      final score =
          e.querySelector('span[id^=comment_score]')?.text.toInt() ?? -99999;

      final voteUser = e
              .querySelector('div[id^=cvotes]')
              ?.text
              .split(',')
              .map((e) => e.trim())
              .toList() ??
          [];

      return CommentModel(
        commentTime: match[1]!,
        username: uploader,
        comment: comment,
        score: score,
        voteUser: voteUser,
      );
    }).toList();
  }
}
