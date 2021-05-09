import 'package:catpic/network/adapter/booru_adapter.dart';
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
    required this.isFavourite,
  }) : super(searchText);

  final BooruAdapter adapter;

  final bool isFavourite;

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
  Future<List<BooruPost>> onLoadNextPage() async {
    final list = await adapter.postList(
      tags: searchText,
      page: page,
      limit: settingStore.eachPageItem,
      cancelToken: cancelToken,
    );
    if (isFavourite) {
      for (final post in list) post.favourite = true;
    }
    return list;
  }

  @override
  int? get pageItemCount => null;

  @override
  @action
  Future<void> onDataChange() async {}
}
