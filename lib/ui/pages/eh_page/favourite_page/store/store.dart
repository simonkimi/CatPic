import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/data/models/gen/eh_preview.pb.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/data/models/gen/eh_storage.pb.dart';
import 'package:catpic/data/models/ehentai/eh_storage.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

class EhFavouriteStore = EhFavouriteStoreBase with _$EhFavouriteStore;

abstract class EhFavouriteStoreBase extends ILoadMore<PreViewItemModel>
    with Store {
  EhFavouriteStoreBase({
    required String searchText,
    required this.adapter,
  })  : ehFavourite = ObservableList.of(
            EHStorage.fromBuffer(adapter.websiteEntity.storage ?? [])
                .favouriteList),
        super(searchText);

  final EHAdapter adapter;

  var currentFavcat = -1;

  final ObservableList<EhFavourite> ehFavourite;

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
    ehFavourite
      ..clear()
      ..addAll(model.favourites);
    print(ehFavourite.length);
    await storageFav(model.favourites);
    return model.previewModel.items;
  }

  Future<void> storageFav(List<EhFavourite> fav) async {
    final entity = adapter.websiteEntity;
    final storage = EHStorage.fromBuffer(entity.storage ?? []);
    storage.favourite
      ..clear()
      ..addAll(fav);
    final newEntity = entity.copyWith(storage: storage.writeToBuffer());
    mainStore.setWebsiteWithoutNotification(newEntity);
    await DB().websiteDao.updateSite(newEntity);
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
