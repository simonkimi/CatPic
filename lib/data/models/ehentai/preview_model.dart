import 'package:flutter/material.dart';

class PreViewItemModel {
  PreViewItemModel({
    required this.gid,
    required this.gtoken,
    required this.title,
    required this.tag,
    required this.uploader,
    required this.uploadTime,
    required this.pages,
    required this.stars,
    required this.targetUrl,
    required this.previewImg,
    required this.language,
    required this.keyTags,
    required this.previewHeight,
    required this.previewWidth,
    this.titleJpn,
  });

  final String title;
  final String tag;
  final String uploader;
  final String uploadTime;
  final int pages;
  final double stars;
  final String language;

  final String targetUrl;
  final String previewImg;
  final List<PreviewTag> keyTags;

  final int previewHeight;
  final int previewWidth;

  final String gid;
  final String gtoken;

  String? titleJpn;

  @override
  String toString() {
    return 'PreViewItemModel title: $title upload: $uploadTime';
  }
}

class PreviewTag {
  PreviewTag({required this.tag, required this.color});

  final String tag;
  final int color;

  @override
  String toString() {
    return '{$tag $color}';
  }
}

Color fromEhTag(String tag) {
  switch (tag) {
    case 'Doujinshi':
      return Colors.red;
    case 'Manga':
      return Colors.orange;
    case 'Artist CG':
      return const Color(0xFFFCC02C);
    case 'Game CG':
      return const Color(0xFF4CB051);
    case 'Western':
      return const Color(0xFF8BC349);
    case 'Non-H':
      return Colors.blue;
    case 'Image Set':
      return const Color(0xFF3F51B6);
    case 'Cosplay':
      return Colors.purple;
    case 'Asian Porn':
      return Colors.pink;
    case 'Misc':
    default:
      return const Color(0xFF999996);
  }
}
