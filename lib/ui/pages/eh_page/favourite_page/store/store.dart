import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/data/models/gen/eh_storage.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

class EhFavouriteStore = EhFavouriteStoreBase with _$EhFavouriteStore;

abstract class EhFavouriteStoreBase extends ILoadMore<PreViewItemModel>
    with Store {
  EhFavouriteStoreBase({
    required String searchText,
    required this.adapter,
  })  : ehFavourite = (() {
          final storage = EHStorage.fromBuffer(mainStore.getStorage() ?? []);
          if (storage.favourite.length != 10) {
            return ObservableList.of(List.generate(
                10,
                (index) => EhFavourite(
                    favcat: index, count: 0, tag: 'Favorites $index')));
          }
          return ObservableList.of(storage.favourite);
        }()),
        super(searchText);

  final EHAdapter adapter;

  final currentFavcat = -1;

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
    final model =
        await adapter.favourite(favcat: currentFavcat, page: page - 1);
    await storageFav(model.favourites);
    return model.previewModel.items;
  }

  Future<void> storageFav(List<EhFavourite> fav) async {
    final entity = mainStore.websiteEntity!;
    final storage = EHStorage.fromBuffer(mainStore.getStorage() ?? []);
    storage.favourite
      ..clear()
      ..addAll(fav);
    final newEntity = entity.copyWith(storage: storage.writeToBuffer());
    mainStore.setWebsiteWithoutNotification(newEntity);
    await DB().websiteDao.updateSite(newEntity);
  }

  @override
  int? get pageItemCount => 50;
}
