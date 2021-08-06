import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/data/models/gen/eh_preview.pb.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

class EhFavouriteStore = EhFavouriteStoreBase with _$EhFavouriteStore;

abstract class EhFavouriteStoreBase extends ILoadMore<PreViewItemModel>
    with Store {
  EhFavouriteStoreBase({
    required String searchText,
    required this.adapter,
  }) : super(searchText);

  final EHAdapter adapter;

  var currentFavcat = -1;

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
    final model = await adapter.favourite(
        favcat: currentFavcat, page: page - 1, searchText: searchText);
    adapter.websiteEntity.favouriteList
      ..clear()
      ..addAll(model.favourites);
    await adapter.websiteEntity.save();
    return model.previewModel.items;
  }

  Future<void> changeSearchCat(int favcat) async {
    currentFavcat = favcat;
    await onNewSearch(searchText);
  }

  @override
  int? get pageItemCount => 50;

  @override
  bool isItemExist(PreViewItemModel item) => false;
}
