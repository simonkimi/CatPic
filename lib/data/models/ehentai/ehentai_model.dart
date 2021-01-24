import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/ui/pages/main_page/models/large_card_model.dart';
import 'package:catpic/ui/pages/main_page/models/simple_card_model.dart';
import '../search_model.dart';

part 'ehentai_model.g.dart';

class EHentaiModel = EHentaiModelBase with _$EHentaiModel;

abstract class EHentaiModelBase extends SearchPageModel with Store {
  EHentaiModelBase(String searchText) : super(searchText);

  @observable
  List<PreViewModel> previewList = [];

  @action
  void loadDetailPage(int id) async {}

  @action
  void loadNextPage() async {}

  @action
  void loadSpecifyPage(int page) async {}

  @computed
  List<SimpleCardModel> get simpleCardList => throw UnimplementedError();

  @computed
  List<LargeCardModel> get largeCardList => throw UnimplementedError();
}
