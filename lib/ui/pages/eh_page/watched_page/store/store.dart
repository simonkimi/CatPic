import 'package:catpic/data/models/ehentai/load_more_with_filter.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/network/api/ehentai/eh_filter.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/utils/utils.dart';

part 'store.g.dart';

class EhWatchedStore = EhWatchedStoreBase with _$EhWatchedStore;

abstract class EhWatchedStoreBase extends ILoadMoreWithFilter<PreViewItemModel>
    with Store {
  EhWatchedStoreBase({
    String searchText = '',
    required this.adapter,
  }) : super(searchText);

  final EHAdapter adapter;

  @override
  @observable
  bool isLoading = false;

  @override
  @observable
  String? lastException;

  @override
  @action
  Future<void> onDataChange() async {}

  @override
  Future<List<PreViewItemModel>> loadPage(int page) async {
    final params = currentFilter.useAdvance
        ? EhFilter.buildAdvanceFilter(
            searchText: searchText,
            filter: currentFilter,
          )
        : EhFilter.buildBasicFilter(
            searchText: searchText,
            filter: currentFilter,
          );

    final result = await adapter.watched(
      filter: params,
      page: page - 1,
    );
    return result.items
        .where((element) =>
            observableList.get((e) => e.gid == element.gid) == null)
        .toList();
  }

  Future<void> applyNewFilter(String tag, bool userFilter) async {
    print('applyNewFilter: $tag');
    currentFilter = filter.copy();
    currentFilter.useAdvance = userFilter;
    searchText = tag;
    await newSearch(tag);
  }

  Future<void> newSearch(String tag) async {
    print('onNewSearch $tag');
    observableList.clear();
    if (lock.locked) {
      cancelToken.cancel();
      cancelToken = CancelToken();
      await lock.synchronized(() {});
    }
    isLoading = true;
    searchText = tag;
    page = 0;
    await onRefresh();
    await onDataChange();
  }

  @override
  int? get pageItemCount => 25;
}
