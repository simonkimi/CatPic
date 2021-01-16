import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/ui/pages/main_page/models/large_card_model.dart';
import 'package:catpic/ui/pages/main_page/models/simple_card_model.dart';

import '../website_model.dart';

class EHentaiModel extends WebsiteModel {
  EHentaiModel(WebsiteEntity websiteEntity) : super(websiteEntity);


  @override
  List<LargeCardModel> toLargeCardModel() {

  }

  @override
  List<SimpleCardModel> toSimpleCardModel() {

  }

  @override
  List getNextPage() {
    // TODO: implement getNextPage
    throw UnimplementedError();
  }
}