import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/main.dart';

part 'store.g.dart';

typedef ItemBuilder = Future<BooruPost> Function(int index);

class PostImageViewStore = PostImageViewStoreBase with _$PostImageViewStore;

abstract class PostImageViewStoreBase with Store {
  PostImageViewStoreBase({
    required this.currentIndex,
    required this.itemBuilder,
    required this.itemCount,
  });

  final ItemBuilder itemBuilder;
  final int itemCount;

  @observable
  bool bottomBarVis = true;

  @observable
  int currentIndex;

  @observable
  BooruPost? loadedBooruPost;

  @action
  void setBottomBarVis(bool value) => bottomBarVis = value;

  @action
  Future<void> setIndex(int value) async {
    currentIndex = value;
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