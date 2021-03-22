import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:flutter/material.dart';

class LargeCardModel {
  LargeCardModel({
    required this.title,
    required this.subTitle,
    required this.stars,
    required this.pages,
    required this.tag,
    required this.subscript,
    required this.tags,
  });

  final String title;
  final String subTitle;
  final double stars;
  final int pages;
  final String tag;
  final String subscript;
  final List<PreviewTag> tags;
}
