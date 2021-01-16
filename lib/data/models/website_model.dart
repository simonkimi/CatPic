import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/ui/pages/main_page/models/large_card_model.dart';
import 'package:catpic/ui/pages/main_page/models/simple_card_model.dart';

abstract class WebsiteModel<T> {
  final WebsiteEntity websiteEntity;
  int pageIndex;

  WebsiteModel(this.websiteEntity);




  List<T> getNextPage();
  List<LargeCardModel> toLargeCardModel();
  List<SimpleCardModel> toSimpleCardModel();

}