import 'package:catpic/data/adapter/booru_adapter.dart';
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
  Future<List<BooruPool>> onLoadNextPage() => adapter.poolList(
        name: searchText,
        page: page,
      );

  @override
  @action
  Future<void> onDataChange() async {}
}
