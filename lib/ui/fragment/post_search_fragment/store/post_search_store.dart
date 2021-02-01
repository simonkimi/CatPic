import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/interface/post_view.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/ui/pages/main_page/models/simple_card_model.dart';
import 'package:mobx/mobx.dart';

part 'post_search_store.g.dart';

class PostSearchStore = PostSearchStoreBase with _$PostSearchStore;

abstract class PostSearchStoreBase with Store implements PostViewInterface {
  final String _searchText;
  final BooruAdapter _booruAdapter;

  PostSearchStoreBase(this._searchText, this._booruAdapter);

  int page = 0;

  List<BooruPost> _booruPostList = [];

  @action
  Future<void> loadNextPage() async {
    var posts =
        await _booruAdapter.postList(limit: 50, page: page, tags: _searchText);
    _booruPostList.addAll(posts);
    page += 1;
  }

  @computed
  List<SimpleCardModel> get simpleCardList {
    return _booruPostList.map((e) {
      return SimpleCardModel(
        title: '#${e.id}',
        subTitle: '${e.width} x ${e.height}',
      );
    });
  }

  @computed
  String get searchText => _searchText;
}
