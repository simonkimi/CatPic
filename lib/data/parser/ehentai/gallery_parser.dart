import 'package:catpic/data/models/ehentai/gallery_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

class GalleryParser {
  final String galleryHtml;

  GalleryParser(this.galleryHtml);

  GalleryModel parse() {
    var document = parser.parse(galleryHtml).body;
    var tags = parseTags(document);
    var favcount = int.parse(
        document.querySelector('#favcount').text.replaceAll(' times', ''));
    var fileSize = document
        .querySelectorAll('#gdd > table > tbody > tr')[4]
        .children[1]
        .text;
    var previewImages = parsePreview(document);
    var maxPageIndex = parseMaxPage(document);
    var comments = parseComment(document);

    return GalleryModel(
      tags: tags,
      favorited: favcount,
      fileSize: fileSize,
      previewImages: previewImages,
      maxPageIndex: maxPageIndex,
      comments: comments
    );
  }

  List<TagModels> parseTags(Element e) {
    var tagElements = e.querySelectorAll('#taglist > table > tbody > tr');
    return tagElements.map((e) {
      var title = e.children[0]?.text ?? '';
      var tags = e.children[1].children.map((e) => e.text).toList();
      title = title.substring(0, title.length - 1);
      return TagModels(key: title, value: tags);
    }).toList();
  }

  /// 解析预览 [0]: 预览URL, [1]: 指向地址
  List<PreviewImage> parsePreview(Element element) {
    var imgContainer = element.querySelectorAll('.gdtm');
    return imgContainer.map((e) {
      var style = e.children[0].attributes['style'];
      var re = RegExp(
          r'height:(\d+)px;\sbackground:transparent\surl\((\S+)\)\s-?(\d+)px');
      var data = re.firstMatch(style);

      var aElement = e.querySelector('a');
      return PreviewImage(
        height: int.parse(data[1]),
        image: data[2],
        positioning: int.parse(data[3]),
        target: aElement.attributes['href'],
      );
    }).toList();
  }

  /// 解析最大面数
  int parseMaxPage(Element element) {
    var bottomBarElements = element.querySelectorAll('.ptb > tbody > tr > td');
    var ele = bottomBarElements[bottomBarElements.length - 2];
    return int.parse(ele.text);
  }

  List<CommentModel> parseComment(Element element) {
    var comments = element.querySelectorAll('.c1');

    return comments.map((e){
      var uploader = e.querySelector('.c3 > a').text ?? '';
      var re = RegExp(r'on\s([\w\s,:]+)\sby');
      var uploadTimeText = e.querySelector('.c3').text;
      var match = re.firstMatch(uploadTimeText);
      var comment = e.querySelector('.c6')?.innerHtml?.replaceAll('<br>', '\n') ?? '';
      var commentDocument = parser.parse(comment);
      comment = commentDocument.body.text;
      return CommentModel(
        commentTime: match[1],
        username: uploader,
        comment: comment
      );
    }).toList();
  }
}
