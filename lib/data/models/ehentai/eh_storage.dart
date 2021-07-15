import 'package:flutter/material.dart';
import 'package:catpic/data/models/gen/eh_storage.pb.dart';

extension EHStorageHelper on EHStorage {
  List<EhFavourite> get favouriteList {
    if (favourite.length != 10) {
      return List.generate(
          10,
          (index) =>
              EhFavourite(favcat: index, count: 0, tag: 'Favorites $index'));
    }
    return favourite;
  }
}

extension EhFavouriteColor on int {
  Color get favcatColor {
    switch (this) {
      case 0:
        return Colors.black54;
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.green;
      case 5:
        return const Color(0xFFa1ee2d);
      case 6:
        return Colors.cyan;
      case 7:
        return Colors.blueAccent;
      case 8:
        return Colors.purple;
      case 9:
        return Colors.pink;
      case -1:
      default:
        return Colors.red;
    }
  }
}
