import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:flutter/material.dart';

class EhGalleryType {
  static const Doujinshi = 0;
  static const Manga = 1;
  static const Artist_CG = 2;
  static const Game_CG = 3;
  static const Western = 4;
  static const Non_H = 5;
  static const Image_Set = 6;
  static const Cosplay = 7;
  static const Asian_Porn = 8;
  static const Misc = 9;
}

extension EhGalleryTypeHelper on int {
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
      default:
        return const Color(0xFF4CB051);
    }
  }

  String translate(BuildContext context) {
    if (!settingStore.ehTranslate) {
      switch (this) {
        case EhGalleryType.Doujinshi:
          return 'Doujinshi';
        case EhGalleryType.Manga:
          return 'Manga';
        case EhGalleryType.Artist_CG:
          return 'Artist CG';
        case EhGalleryType.Game_CG:
          return 'Game CG';
        case EhGalleryType.Western:
          return 'Western';
        case EhGalleryType.Non_H:
          return 'Non H';
        case EhGalleryType.Image_Set:
          return 'Image Set';
        case EhGalleryType.Cosplay:
          return 'Cosplay';
        case EhGalleryType.Asian_Porn:
          return 'Asian Porn';
        case EhGalleryType.Misc:
        default:
          return 'Misc';
      }
    }

    switch (this) {
      case EhGalleryType.Doujinshi:
        return I18n.of(context).doujinshi;
      case EhGalleryType.Manga:
        return I18n.of(context).manga;
      case EhGalleryType.Artist_CG:
        return I18n.of(context).artist_cg;
      case EhGalleryType.Game_CG:
        return I18n.of(context).game_cg;
      case EhGalleryType.Western:
        return I18n.of(context).western;
      case EhGalleryType.Non_H:
        return I18n.of(context).non_h;
      case EhGalleryType.Image_Set:
        return I18n.of(context).image_set;
      case EhGalleryType.Cosplay:
        return I18n.of(context).cosplay;
      case EhGalleryType.Asian_Porn:
        return I18n.of(context).asian_porn;
      case EhGalleryType.Misc:
      default:
        return I18n.of(context).misc;
    }
  }
}

int fromEhTag(String tag) {
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
