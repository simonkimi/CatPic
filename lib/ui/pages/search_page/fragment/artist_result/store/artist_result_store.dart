import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/models/booru/booru_artist.dart';
import 'package:catpic/data/models/booru/load_more.dart';
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
  Future<List<BooruArtist>> onLoadNextPage() =>
      adapter.artistList(name: searchText, page: page);

  @action
  @override
  Future<void> onDataChange() async {}
}
