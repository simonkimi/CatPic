import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';


enum SupportPage {
  POSTS, POOLS, ARTISTS, TAGS
}


abstract class BooruAdapter {
  List<SupportPage> getSupportPage();

  Future<List<BooruPost>> postList({String tags, int page, int limit});

  Future<List<BooruTag>> tagList({String name, int page, int limit});
}
