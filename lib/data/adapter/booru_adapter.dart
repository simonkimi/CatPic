import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:dio/dio.dart';

enum SupportPage { POSTS, POOLS, ARTISTS, TAGS }

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
  });

  Dio get dio;
}
