import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/network/api/ehentai/eh_filter.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

class EhIndexStore = EhIndexStoreBase with _$EhIndexStore;

abstract class EhIndexStoreBase extends ILoadMore<PreViewModel> with Store {
  EhIndexStoreBase({
    String searchText = '',
    required this.adapter,
  }) : super(searchText);

  final EHAdapter adapter;

  @override
  @observable
  bool isLoading = false;

  @override
  @action
  Future<void> onDataChange() async {}

  @override
  Future<List<PreViewModel>> onLoadNextPage() => adapter.index(
        filter: EhFilter.buildAdvanceFilter(
          searchText: searchText,
        ),
        page: page,
      );

  @override
  int? get pageItemCount => 25;
}
