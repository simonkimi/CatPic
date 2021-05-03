import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/main.dart';
import 'package:mobx/mobx.dart';

part 'post_result_store.g.dart';

class PostResultStore = PostResultStoreBase with _$PostResultStore;

abstract class PostResultStoreBase extends ILoadMore<BooruPost> with Store {
  PostResultStoreBase({
    String searchText = '',
    required this.adapter,
  }) : super(searchText);

  final BooruAdapter adapter;

  @override
  @observable
  bool isLoading = false;

  @computed
  List<BooruPost> get postList {
    if (settingStore.saveModel) {
      return observableList.where((e) => e.rating == PostRating.SAFE).toList();
    }
    return observableList;
  }

  @override
  Future<List<BooruPost>> onLoadNextPage() => adapter.postList(
        tags: searchText,
        page: page,
        limit: settingStore.eachPageItem,
        cancelToken: cancelToken,
      );

  @override
  int get pageItemCount => settingStore.eachPageItem;

  @override
  @action
  Future<void> onDataChange() async {}
}
