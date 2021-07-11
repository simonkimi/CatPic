import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:mobx/mobx.dart';

part 'pool_result_store.g.dart';

class PoolResultStore = PoolResultStoreBase with _$PoolResultStore;

abstract class PoolResultStoreBase extends ILoadMore<BooruPool> with Store {
  PoolResultStoreBase({
    String searchText = '',
    required this.adapter,
  }) : super(searchText);

  final BooruAdapter adapter;

  @override
  @observable
  bool isLoading = false;

  @override
  Future<List<BooruPool>> loadPage(int page) => adapter.poolList(
        name: searchText,
        page: page,
      );

  @override
  bool isItemExist(BooruPool item) => false;

  List<BooruPool> get poolList =>
      observableList.where((element) => element.postCount > 0).toList();

  @override
  int? get pageItemCount => null;

  @override
  @action
  Future<void> onDataChange() async {}
}
