import 'package:catpic/data/models/booru/booru_artist.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:mobx/mobx.dart';

part 'artist_result_store.g.dart';

class ArtistResultStore = ArtistResultStoreBase with _$ArtistResultStore;

abstract class ArtistResultStoreBase extends ILoadMore<BooruArtist> with Store {
  ArtistResultStoreBase({
    required String searchText,
    required this.adapter,
  }) : super(searchText);

  final BooruAdapter adapter;

  @override
  int? get pageItemCount => null;

  @override
  @observable
  bool isLoading = false;

  @override
  Future<List<BooruArtist>> loadPage(page) =>
      adapter.artistList(name: searchText, page: page);

  @override
  bool isItemExist(BooruArtist item) => false;

  @action
  @override
  Future<void> onDataChange() async {}
}
