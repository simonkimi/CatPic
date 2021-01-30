import 'package:catpic/data/models/base/booru_post.dart';


enum SupportPage {
  POSTS, POOLS, ARTISTS,
}


abstract class BooruAdapter {
  List<SupportPage> getSupportPage();

  Future<List<BooruPost>> postList({String tags, int page, int limit});
}
