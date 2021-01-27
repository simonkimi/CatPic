import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/network/api/ehentai/eh_filter.dart';
import 'file:///H:/Android/Porject/CatPic/lib/network/client/eh_client.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/ui/pages/main_page/models/large_card_model.dart';
import 'package:catpic/ui/pages/main_page/models/simple_card_model.dart';
import '../search_model.dart';

part 'ehentai_model.g.dart';

class EHentaiModel = EHentaiModelBase with _$EHentaiModel;

abstract class EHentaiModelBase extends SearchPageModel with Store {
  final WebsiteEntity entity;

  EhClient client;
  int page = 0;

  EHentaiModelBase(String searchText, this.entity) : super(searchText) {
    client = EhClient(entity);
  }


  @observable
  List<PreViewModel> previewList = [];

  @action
  Future<void> loadDetailPage(int id) async {}

  @action
  Future<void> loadNextPage() async {
    await client.getIndex(EhFilter.buildAdvanceFilter(
      page: page
    ));
    page += 1;
  }

  @action
  Future<void> loadSpecifyPage(int page) async {}

  @computed
  List<SimpleCardModel> get simpleCardList => throw UnimplementedError();

  @computed
  List<LargeCardModel> get largeCardList => throw UnimplementedError();
}
