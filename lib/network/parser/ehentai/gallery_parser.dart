import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:catpic/utils/utils.dart';
import 'package:tuple/tuple.dart';

class GalleryParser {
  static GalleryModel parse(String galleryHtml) {
    final document = parser.parse(galleryHtml).body!;
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
    final uploader = document.querySelector('#gdn')?.text.trim() ?? '';
    final visible = document
        .querySelectorAll('#gdd > table > tbody > tr')[2]
        .children[1]
        .text;
    final imageCount = document
        .querySelectorAll('#gdd > table > tbody > tr')[5]
        .children[1]
        .text
        .replaceAll(' pages', '')
        .toInt();
    final uploadTime = document
        .querySelectorAll('#gdd > table > tbody > tr')[0]
        .children[1]
        .text
        .trim();
    final language = document
        .querySelectorAll('#gdd > table > tbody > tr')[3]
        .children[1]
        .text
        .replaceAll(' ', '');
    final starMember =
        document.querySelector('#rating_count')?.text.toInt() ?? 0;
    final star = document
            .querySelector('#rating_label')
            ?.text
            .replaceAll('Average: ', '')
            .toDouble() ??
        0.0;
    final gid = parseGid(document);
    final previewSize = parsePreviewImageSize(document);
    final startEndPage = parseStartEndPage(document);

    return GalleryModel(
      gid: gid.item1,
      token: gid.item2,
      title: document.querySelector('#gn')!.text,
      tags: parseTags(document),
      favorited: favcount,
      fileSize: fileSize,
      previewImages: document.querySelector('#gdo4  > .ths')!.text == 'Large'
          ? parseLargePreview(document)
          : parseNormalPreview(document),
      maxPageIndex: parseMaxPage(document),
      comments: parseComment(document),
      parent: parseParent(document),
      visible: visible,
      imageCount: imageCount,
      language: language,
      favcat: parseFavCat(document),
      torrentNum: parseTorrentNum(document),
      japanTitle: document.querySelector('#gj')?.text.trim() ?? '',
      uploader: uploader,
      uploadTime: uploadTime,
      star: star,
      starMember: starMember,
      previewImage: parsePreviewImage(document),
      tag: fromEhTag(document.querySelector('#gdc > .cs')?.text ?? ''),
      previewWidth: previewSize.item1,
      previewHeight: previewSize.item2,
      currentPage: document.querySelector('.ptds > a')!.text.toInt(),
      imageCountInOnePage: parseImageCountPage(document),
      startImageIndex: startEndPage.item1,
      endImageIndex: startEndPage.item2,
      updates: parseUpdates(document),
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
      return TagModels(
          key: title,
          value: tags.map((e) => TagItem(parent: title, value: e)).toList());
    }).toList();
  }

  /// 解析预览 [0]: 预览URL, [1]: 指向地址
  static List<GalleryPreviewImageModel> parseNormalPreview(Element element) {
    final imgContainer = element.querySelectorAll('.gdtm');
    return imgContainer.map((e) {
      final style = e.children[0].attributes['style'];
      final re = RegExp(
          r'width:(\d+)px; height:(\d+)px;\sbackground:transparent\surl\((\S+)\)\s-?(\d+)px');
      final data = re.firstMatch(style!)!;
      final aElement = e.querySelector('a')!;

      final reg = RegExp(r's/(.+?)/(\d+)-(\d+)');
      final match = reg.firstMatch(aElement.attributes['href']!)!;
      final shaToken = match[1]!;
      final gid = match[2]!;
      final page = match[3]!.toInt();

      return GalleryPreviewImageModel(
        width: data[1]?.toInt() ?? 0,
        height: data[2]?.toInt() ?? 0,
        imageUrl: data[3]!,
        positioning: data[4]?.toInt() ?? 0,
        page: page,
        gid: gid,
        shaToken: shaToken,
      );
    }).toList();
  }

  static List<GalleryPreviewImageModel> parseLargePreview(Element document) {
    final container = document.querySelectorAll('.gdtl');
    return container.map((e) {
      final aElement = e.querySelector('a')!;
      final reg = RegExp(r's/(.+?)/(\d+)-(\d+)');
      final match = reg.firstMatch(aElement.attributes['href']!)!;
      final shaToken = match[1]!;
      final gid = match[2]!;
      final page = match[3]!.toInt();

      final height = e.attributes['style']!
          .replaceAll('height:', '')
          .replaceAll('px', '')
          .toInt();

      return GalleryPreviewImageModel(
        width: 239,
        shaToken: shaToken,
        gid: gid,
        page: page,
        isLarge: true,
        imageUrl: e.querySelector('img')?.attributes['src'],
        height: height,
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

  static int parseFavCat(Element element) {
    final i = element.querySelector('#fav > .i');
    if (i == null) return -1;
    final re = RegExp(r'\d+px\s-(\d+)px;');
    final match = re.firstMatch(i.attributes['style']!)!;
    return (match[1]!.toInt() - 2) ~/ 19;
  }

  static int parseTorrentNum(Element element) {
    final g2 = element.querySelectorAll('#gd5 > .g2');
    final re = RegExp(r'(\d+)');
    final match = re.firstMatch(g2[1].text);
    return match?[1]?.toInt() ?? 0;
  }

  static Tuple2<String, String> parseGid(Element element) {
    final g3 = element.querySelector('.g3 > a')!;
    final reg = RegExp(r'g/(\d+)/(.+)/');
    final match = reg.firstMatch(g3.attributes['href']!)!;
    final gid = match[1]!;
    final token = match[2]!;
    return Tuple2(gid, token);
  }

  static String parsePreviewImage(Element element) {
    final gd1 = element.querySelector('#gd1 > div')!;
    final re = RegExp(r'url\((.+?)\)');
    final match = re.firstMatch(gd1.attributes['style']!)!;
    return match[1]!;
  }

  static List<GalleryUpdate> parseUpdates(Element document) {
    final update = <GalleryUpdate>[];
    var pointer = 0;
    for (final node in document.querySelector('#gnd')!.nodes) {
      if (node.nodeType == Node.ELEMENT_NODE &&
          node.attributes.containsKey('href')) {
        final reg = RegExp(r'g/(\d+)/(.+)/');
        final match = reg.firstMatch(node.attributes['href']!)!;
        update.add(GalleryUpdate(gid: match[1]!, token: match[2]!));
      } else if (node.nodeType == Node.TEXT_NODE) {
        final reg = RegExp(r'\d+-\d+-\d+\s\d+:\d+');
        final match = reg.firstMatch(node.text!)!;
        update[pointer].updateTime = match[0]!;
        pointer += 1;
      }
    }
    return update;
  }

  static Tuple2<int, int> parsePreviewImageSize(Element document) {
    final gd1 = document.querySelector('#gd1 > div')!;
    final re = RegExp(r'width:(\d+)px;\sheight:(\d+)px;');
    final match = re.firstMatch(gd1.attributes['style']!)!;
    return Tuple2(match[1]!.toInt(), match[2]!.toInt());
  }

  static Tuple2<int, int> parseStartEndPage(Element document) {
    final gpc = document.querySelector('.gpc')!;
    final re = RegExp(r'(\d+)\s-\s(\d+)');
    final match = re.firstMatch(gpc.text)!;
    return Tuple2(match[1]!.toInt() - 1, match[2]!.toInt() - 1);
  }

  static int parseImageCountPage(Element document) {
    final gdo2 = document.querySelector('#gdo2 > .ths')!;
    final gdo4 = document.querySelector('#gdo4  > .ths')!;
    final rows = gdo2.text.replaceAll(' rows', '').toInt();
    final columns = gdo4.text == 'Large' ? 5 : 10;
    return rows * columns;
  }
}
