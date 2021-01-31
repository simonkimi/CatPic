import 'package:catpic/ui/pages/main_page/models/simple_card_model.dart';

abstract class PostViewInterface {
  final String searchText;

  PostViewInterface(this.searchText);

  Future<void> loadNextPage();

  List<SimpleCardModel> get simpleCardList;
}
