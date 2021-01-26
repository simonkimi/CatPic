import 'package:catpic/ui/pages/main_page/models/large_card_model.dart';
import 'package:catpic/ui/pages/main_page/models/simple_card_model.dart';

abstract class SearchPageModel {
  final String searchText;

  SearchPageModel(this.searchText);

  List<LargeCardModel> get largeCardList;

  List<SimpleCardModel> get simpleCardList;

  void loadNextPage();

  void loadSpecifyPage(int page);

  void loadDetailPage(int id);
}