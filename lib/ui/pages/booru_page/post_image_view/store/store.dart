import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/page_slider.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

typedef ItemBuilder = Future<BooruPost> Function(int index);

class PostImageViewStore = PostImageViewStoreBase with _$PostImageViewStore;

abstract class PostImageViewStoreBase with Store {
  PostImageViewStoreBase({
    required this.currentIndex,
    required List<BooruPost> postList,
    this.adapter,
  }) : postList = ObservableList.of(postList);

  final pageSliderController = PageSliderController();

  final ObservableList<BooruPost> postList;

  final BooruAdapter? adapter;

  @observable
  int currentIndex;

  @computed
  BooruPost get booruPost => postList[currentIndex];

  @observable
  var infoBarDisplay = settingStore.toolbarOpen;

  @observable
  var pageBarDisplay = false;

  @action
  void setInfoBarDisplay(bool value) {
    infoBarDisplay = value;
    settingStore.setToolbarOpen(value);
  }

  @action
  void setInfoBarDisplayWithoutSave(bool value) {
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
    final loadedBooruPost = postList[value];
    final dao = DB().tagDao;
    for (final tags in loadedBooruPost.tags.values) {
      for (final tagStr in tags) {
        if (tagStr.isNotEmpty) {
          await dao.insert(TagTableCompanion.insert(
            website: adapter!.website.id,
            tag: tagStr,
          ));
        }
      }
    }
  }

  @action
  Future<bool> changeFavouriteState() async {
    if (booruPost.favourite) {
      await unFavourite();
      return false;
    } else {
      await favourite();
      return true;
    }
  }

  @action
  Future<void> favourite() async {
    try {
      final username = adapter!.website.username!;
      final password = adapter!.website.password!;
      await adapter!.favourite(booruPost.id, username, password);
      postList[currentIndex] = booruPost.copyWith(favourite: true);
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        BotToast.showText(text: I18n.g.http_401);
      }
      BotToast.showText(text: e.message);
    }
  }

  @action
  Future<void> unFavourite() async {
    try {
      final username = adapter!.website.username!;
      final password = adapter!.website.password!;
      await adapter!.unFavourite(booruPost.id, username, password);
      postList[currentIndex] = booruPost.copyWith(favourite: false);
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        BotToast.showText(text: I18n.g.http_401);
      }
      BotToast.showText(text: e.message);
    }
  }
}
