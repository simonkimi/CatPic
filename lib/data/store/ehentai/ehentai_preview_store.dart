import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/data/parser/ehentai/preview_parser.dart';
import 'package:catpic/network/api/ehentai/eh_client.dart';
import 'package:catpic/network/api/ehentai/eh_filter.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/ui/pages/main_page/models/large_card_model.dart';
import 'package:catpic/ui/pages/main_page/models/simple_card_model.dart';
import 'package:catpic/data/interface/post_view.dart';

part 'ehentai_preview_store.g.dart';

class EHentaiPreviewStore = EHentaiPreviewStoreBase with _$EHentaiPreviewStore;

abstract class EHentaiPreviewStoreBase extends PostViewInterface with Store {
  final WebsiteEntity entity;

  EhClient client;
  int page = 0;

  EHentaiPreviewStoreBase(String searchText, this.entity) : super(searchText) {
    client = EhClient(entity);
  }

  @observable
  List<PreViewModel> previewList = [];

  @action
  Future<void> loadDetailPage(int id) async {}

  @action
  Future<void> loadNextPage() async {
    var pageHtml =
        await client.getIndex(EhFilter.buildAdvanceFilter(page: page));
    previewList.addAll(PreviewParser(pageHtml).parse());
    page += 1;
  }

  @action
  Future<void> loadSpecifyPage(int page) async {}

  @computed
  List<SimpleCardModel> get simpleCardList => previewList.map((e) {
        return SimpleCardModel(
          title: e.title,
          subTitle: "${e.previewWidth} * ${e.previewHeight}",
        );
      }).toList();

  @computed
  List<LargeCardModel> get largeCardList => previewList.map((e) {
        return LargeCardModel(
          title: e.title,
          subTitle: e.uploader,
          stars: e.stars,
          pages: e.pages,
          tags: e.keyTags,
          subscript: e.uploadTime,
          tag: e.tag,
        );
      }).toList();
}
