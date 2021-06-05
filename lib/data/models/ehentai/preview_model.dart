import 'package:catpic/i18n.dart';
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
  final EhGalleryType tag;
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
  PreviewTag({
    required this.tag,
    required this.color,
    this.translate,
  });

  final String tag;
  String? translate;
  final int color;

  @override
  String toString() {
    return '{$tag $color}';
  }
}

enum EhGalleryType {
  Doujinshi,
  Manga,
  Artist_CG,
  Game_CG,
  Western,
  Non_H,
  Image_Set,
  Cosplay,
  Asian_Porn,
  Misc,
}

extension EhGalleryTypeHelper on EhGalleryType {
  Color get color {
    switch (this) {
      case EhGalleryType.Doujinshi:
        return Colors.red;
      case EhGalleryType.Manga:
        return Colors.orange;
      case EhGalleryType.Artist_CG:
        return const Color(0xFFFCC02C);
      case EhGalleryType.Western:
        return const Color(0xFF8BC349);
      case EhGalleryType.Non_H:
        return Colors.blue;
      case EhGalleryType.Image_Set:
        return const Color(0xFF3F51B6);
      case EhGalleryType.Cosplay:
        return Colors.purple;
      case EhGalleryType.Asian_Porn:
        return Colors.pink;
      case EhGalleryType.Misc:
        return const Color(0xFF999996);
      case EhGalleryType.Game_CG:
        return const Color(0xFF4CB051);
    }
  }

  String get string {
    switch (this) {
      case EhGalleryType.Doujinshi:
        return I18n.g.doujinshi;
      case EhGalleryType.Manga:
        return I18n.g.manga;
      case EhGalleryType.Artist_CG:
        return I18n.g.artist_cg;
      case EhGalleryType.Game_CG:
        return I18n.g.game_cg;
      case EhGalleryType.Western:
        return I18n.g.western;
      case EhGalleryType.Non_H:
        return I18n.g.non_h;
      case EhGalleryType.Image_Set:
        return I18n.g.image_set;
      case EhGalleryType.Cosplay:
        return I18n.g.cosplay;
      case EhGalleryType.Asian_Porn:
        return I18n.g.asian_porn;
      case EhGalleryType.Misc:
        return I18n.g.misc;
    }
  }
}

EhGalleryType fromEhTag(String tag) {
  switch (tag) {
    case '1':
    case 'Doujinshi':
      return EhGalleryType.Doujinshi;
    case '2':
    case 'Manga':
      return EhGalleryType.Manga;
    case '3':
    case 'Artist CG':
      return EhGalleryType.Artist_CG;
    case '4':
    case 'Game CG':
      return EhGalleryType.Game_CG;
    case '5':
    case 'Western':
      return EhGalleryType.Western;
    case '6':
    case 'Non-H':
      return EhGalleryType.Non_H;
    case '7':
    case 'Image Set':
      return EhGalleryType.Image_Set;
    case '8':
    case 'Cosplay':
      return EhGalleryType.Cosplay;
    case '9':
    case 'Asian Porn':
      return EhGalleryType.Asian_Porn;
    case '10':
    case 'Misc':
    default:
      return EhGalleryType.Misc;
  }
}
