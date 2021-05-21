import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

class PopularResultStore = PopularResultStoreBase with _$PopularResultStore;

abstract class PopularResultStoreBase extends ILoadMore<BooruPost> with Store {
  PopularResultStoreBase({
    required String searchText,
    required this.adapter,
  }) : super(searchText);

  final BooruAdapter adapter;
  @observable
  PopularType popularType = PopularType.DAY;

  @observable
  int year = DateTime.now().year;
  @observable
  int month = DateTime.now().month;
  @observable
  int day = DateTime.now().day;

  @override
  @observable
  bool isLoading = false;

  @action
  Future<void> setDate(int yearValue, int monthValue, int dayValue) async {
    year = yearValue;
    month = monthValue;
    day = dayValue;
    await onRefresh();
  }

  @action
  Future<void> setType(PopularType type) async {
    popularType = type;
    await onRefresh();
  }

  @computed
  List<BooruPost> get postList {
    if (settingStore.saveModel) {
      return observableList.where((e) => e.rating == PostRating.SAFE).toList();
    }
    return observableList;
  }

  @override
  Future<List<BooruPost>> loadPage(int page) {
    if (adapter.website.type == WebsiteType.MOEBOORU.index && page >= 2)
      return Future.value([]);
    return adapter.hotList(
      year: year,
      month: month,
      day: day,
      popularType: popularType,
      page: page,
      limit: settingStore.eachPageItem,
    );
  }

  @override
  int? get pageItemCount => null;

  @override
  @action
  Future<void> onDataChange() async {}
}
