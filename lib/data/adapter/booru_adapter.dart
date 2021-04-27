import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:dio/dio.dart';

enum SupportPage {
  POSTS,
  POOLS,
  ARTISTS,
  TAGS,
}

enum Order {
  NAME,
  COUNT,
  Date,
}

abstract class BooruAdapter {
  List<SupportPage> getSupportPage();

  Future<List<BooruPost>> postList({
    required String tags,
    required int page,
    required int limit,
  });

  Future<List<BooruTag>> tagList({
    required String name,
    required int page,
    required int limit,
    CancelToken? cancelToken,
  });

  Future<List<BooruPool>> poolList({
    required String name,
    required int page,
  });

  Dio get dio;
}

extension OrderUtil on Order {
  String get string {
    switch (this) {
      case Order.NAME:
        return 'name';
      case Order.COUNT:
        return 'count';
      case Order.Date:
        return 'date';
    }
  }
}
