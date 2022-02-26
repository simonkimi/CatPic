import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:mobx/mobx.dart';

part 'tag_result_store.g.dart';

class TagResultStore = TagResultStoreBase with _$TagResultStore;

abstract class TagResultStoreBase extends ILoadMore<BooruTag> with Store {
  TagResultStoreBase({
    required String searchText,
    required this.adapter,
  }) : super(searchText);

  final BooruAdapter adapter;

  @override
  int? get pageItemCount => settingStore.eachPageItem;

  @override
  @observable
  bool isLoading = false;

  @override
  Future<List<BooruTag>> loadPage(int page) => adapter.tagList(
      name: searchText, page: page, limit: settingStore.eachPageItem);

  @action
  @override
  Future<void> onDataChange() async {}

  @override
  bool isItemExist(BooruTag item) => false;
}
