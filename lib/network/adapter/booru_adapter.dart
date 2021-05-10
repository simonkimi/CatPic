import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/data/models/booru/booru_artist.dart';
import 'package:catpic/data/models/booru/booru_comment.dart';
import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:dio/dio.dart';

import 'base_adapter.dart';
import 'danbooru_adapter.dart';
import 'gelbooru_adapter.dart';
import 'moebooru_adapter.dart';

enum Order {
  NAME,
  COUNT,
  Date,
}

enum PopularType {
  DAY,
  WEEK,
  MONTH,
}

enum SupportPage {
  POSTS,
  POOLS,
  ARTISTS,
  TAGS,
  FAVOURITE,
}

abstract class BooruAdapter extends Adapter {
  factory BooruAdapter.fromWebsite(WebsiteTableData table) {
    if (table.type == WebsiteType.GELBOORU.index) {
      return GelbooruAdapter(table);
    } else if (table.type == WebsiteType.MOEBOORU.index) {
      return MoebooruAdapter(table);
    } else if (table.type == WebsiteType.DANBOORU.index) {
      return DanbooruAdapter(table);
    }
    throw Exception('Unsupported');
  }

  List<SupportPage> getSupportPage();

  Future<List<BooruPost>> postList({
    required String tags,
    required int page,
    required int limit,
    CancelToken? cancelToken,
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

  Future<List<BooruArtist>> artistList({
    required String name,
    required int page,
  });

  Future<List<BooruPost>> hotList({
    required int year,
    required int month,
    required int day,
    required PopularType popularType,
    required int page,
    required int limit,
  });

  Future<List<BooruComments>> comment({required String id});

  String favouriteList(String username);

  Future<void> favourite(String postId, String username, String password);

  Future<void> unFavourite(String postId, String username, String password);
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
