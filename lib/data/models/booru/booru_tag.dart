import 'package:catpic/i18n.dart';
import 'package:flutter/material.dart';

enum BooruTagType {
  GENERAL,
  COPYRIGHT,
  ARTIST,
  CHARACTER,
  METADATA,
}

class BooruTag {
  BooruTag({
    required this.id,
    required this.count,
    required this.name,
    required this.type,
  });

  final String id;
  final int count;
  final String name;
  final BooruTagType type;

  @override
  String toString() {
    return '$name: $count';
  }
}

extension BooruTagTypeHelper on BooruTagType {
  String get string {
    switch (this) {
      case BooruTagType.GENERAL:
        return I18n.g.general;
      case BooruTagType.ARTIST:
        return I18n.g.artist;
      case BooruTagType.CHARACTER:
        return I18n.g.character;
      case BooruTagType.COPYRIGHT:
        return I18n.g.copyright;
      case BooruTagType.METADATA:
        return I18n.g.metadata;
    }
  }

  Color? get color {
    switch (this) {
      case BooruTagType.GENERAL:
        return null;
      case BooruTagType.ARTIST:
        return Colors.red;
      case BooruTagType.CHARACTER:
        return Colors.green;
      case BooruTagType.COPYRIGHT:
        return Colors.pink;
      case BooruTagType.METADATA:
        return Colors.orange;
    }
  }
}
