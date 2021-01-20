import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/ui/pages/main_page/models/large_card_model.dart';
import 'package:catpic/ui/pages/main_page/models/simple_card_model.dart';
import 'package:catpic/ui/store/website_store.dart';
import 'package:mobx/mobx.dart';

part 'ehentai_model.g.dart';

class EHentaiModel = EHentaiModelBase with _$EHentaiModel;

abstract class EHentaiModelBase with Store implements WebsiteStore {
  final WebsiteEntity entity;

  EHentaiModelBase(this.entity);

  int pageIndex;

  ObservableList galleryList = ObservableList.of([]);

  @action
  void loadNextPage() {}

  @action
  void loadSpecifyPage(int page) {}

  @computed
  List<LargeCardModel> get largeCardList => throw UnimplementedError();

  @computed
  List<SimpleCardModel> get simpleCardList => throw UnimplementedError();


}


