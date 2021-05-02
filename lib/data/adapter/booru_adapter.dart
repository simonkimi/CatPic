import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/data/models/booru/booru_artist.dart';
import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:dio/dio.dart';

import 'danbooru_adapter.dart';
import 'gelbooru_adapter.dart';
import 'moebooru_adapter.dart';

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

  Dio get dio;

  BaseClient get client;
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
