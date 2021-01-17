import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/ui/pages/main_page/models/large_card_model.dart';
import 'package:catpic/ui/pages/main_page/models/simple_card_model.dart';
import 'package:mobx/mobx.dart';

abstract class WebsiteStore<T> {
  List<LargeCardModel> get largeCardList;
  List<SimpleCardModel> get simpleCardList;
  List<T> getNextPage();
}