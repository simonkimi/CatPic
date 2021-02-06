import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/exception/no_more_page.dart';
import 'package:catpic/data/interface/post_view.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'post_result_store.g.dart';

class PostResultStore = PostResultStoreBase with _$PostResultStore;

abstract class PostResultStoreBase with Store implements PostViewInterface{
  final String searchText;
  final BooruAdapter adapter;

  PostResultStoreBase({
    @required this.searchText,
    @required this.adapter,
  });


  var postList = ObservableList<BooruPost>();
  var page = 0;

  @action
  Future<void> loadNextPage() async {
    var list = await adapter.postList(tags: searchText, page: page, limit: 50);
    if (list.isEmpty) {
        throw NoMorePage();
    }
    postList.addAll(list);
  }
}
