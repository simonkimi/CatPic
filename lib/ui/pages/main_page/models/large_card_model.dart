import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:flutter/cupertino.dart';

class LargeCardModel {
  final String title;
  final String subTitle;
  final int stars;
  final int pages;
  final String tag;
  final String subscript;
  final List<PreviewTag> tags;

  LargeCardModel({
    @required this.title,
    @required this.subTitle,
    @required this.stars,
    @required this.pages,
    @required this.tag,
    @required this.subscript,
    @required this.tags,
  });
}
