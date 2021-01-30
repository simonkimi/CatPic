import 'package:catpic/ui/pages/main_page/models/simple_card_model.dart';

abstract class SearchPageStore {
  final String searchText;

  SearchPageStore(this.searchText);

  Future<void> loadNextPage();

  List<SimpleCardModel> get simpleCardList;
}
