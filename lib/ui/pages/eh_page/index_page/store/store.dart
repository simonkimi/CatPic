import 'package:catpic/data/models/ehentai/load_more_with_filter.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/network/api/ehentai/eh_filter.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/utils/utils.dart';

part 'store.g.dart';

class EhIndexStore = EhIndexStoreBase with _$EhIndexStore;

abstract class EhIndexStoreBase extends ILoadMoreWithFilter<PreViewItemModel>
    with Store {
  EhIndexStoreBase({
    String searchText = '',
    required this.adapter,
    EhAdvanceFilter? baseFilter,
  }) : super(
          searchText,
          baseFilter: baseFilter,
        );

  final EHAdapter adapter;

  @override
  @observable
  bool isLoading = false;

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
    final result = await adapter.index(
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
