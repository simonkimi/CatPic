import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/main.dart';

import '../page_slider.dart';

part 'store.g.dart';

typedef ItemBuilder = Future<BooruPost> Function(int index);

class PostImageViewStore = PostImageViewStoreBase with _$PostImageViewStore;

abstract class PostImageViewStoreBase with Store {
  PostImageViewStoreBase({
    required this.currentIndex,
    required this.itemBuilder,
    required this.itemCount,
  });

  final PageSliderController pageSliderController = PageSliderController();

  final ItemBuilder itemBuilder;
  final int itemCount;

  @observable
  int currentIndex;

  @observable
  BooruPost? loadedBooruPost;

  @observable
  var infoBarDisplay = false;

  @observable
  var pageBarDisplay = false;

  @action
  void setInfoBarDisplay(bool value) {
    infoBarDisplay = value;
  }

  @action
  void setPageBarDisplay(bool value) {
    pageBarDisplay = value;
  }

  @action
  Future<void> setIndex(int value) async {
    currentIndex = value;
    pageSliderController.setValue(value);
    loadedBooruPost = await itemBuilder(value);
    final dao = DatabaseHelper().tagDao;
    for (final tags in loadedBooruPost!.tags.values) {
      for (final tagStr in tags) {
        if (tagStr.isNotEmpty) {
          await dao.insert(TagTableCompanion.insert(
            website: mainStore.websiteEntity!.id,
            tag: tagStr,
          ));
        }
      }
    }
  }
}
