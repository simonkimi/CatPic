import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/network/api/ehentai/eh_filter.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:get/get.dart';

part 'store.g.dart';

class EhIndexStore = EhIndexStoreBase with _$EhIndexStore;

abstract class EhIndexStoreBase extends ILoadMore<PreViewItemModel> with Store {
  EhIndexStoreBase({
    String searchText = '',
    required this.adapter,
  }) : super(searchText);

  final EHAdapter adapter;

  DateTime lastClickBack = DateTime.now();

  @override
  @observable
  bool isLoading = false;

  @override
  @action
  Future<void> onDataChange() async {}

  final EhAdvanceFilter filter = EhAdvanceFilter();

  EhAdvanceFilter currentFilter = EhAdvanceFilter();

  var useAdvance = false.obs;

  @override
  Future<List<PreViewItemModel>> loadPage(int page) async {
    final params = useAdvance.value
        ? EhFilter.buildAdvanceFilter(
            searchText: searchText,
            filter: currentFilter,
          )
        : EhFilter.buildBasicFilter(
            searchText: searchText,
            filter: filter,
          );

    final result = await adapter.index(
      filter: params,
      page: page - 1,
    );
    return result.items;
  }

  Future<void> applyNewFilter(String tag) async {
    currentFilter = filter;
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
