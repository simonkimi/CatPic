import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/main.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:catpic/i18n.dart';

part 'post_result_store.g.dart';

class PostResultStore = PostResultStoreBase with _$PostResultStore;

class NoMorePage implements Exception {}

abstract class IPostView {
  IPostView(this.searchText);

  final String searchText;

  Future<void> loadNextPage();
}

abstract class PostResultStoreBase with Store implements IPostView {
  PostResultStoreBase({
    required this.searchText,
    required this.adapter,
  }) {
    refresh();
  }

  final BooruAdapter adapter;

  @override
  String searchText;

  var postList = ObservableList<BooruPost>();
  var page = 0;
  final refreshController = RefreshController();

  Future<void> onRefresh() async {
    print('onRefresh');
    try {
      await refresh();
      refreshController.loadComplete();
      refreshController.refreshCompleted();
    } on NoMorePage {
      refreshController.loadNoData();
      refreshController.refreshCompleted();
    } on DioError catch (e) {
      refreshController.loadFailed();
      refreshController.refreshFailed();
      BotToast.showText(text: '${I18n.g.network_error}:${e.message}');
      print(e.message);
    } catch (e) {
      print(e.toString());
      refreshController.loadFailed();
      refreshController.refreshFailed();
      BotToast.showText(text: e.toString());
      print(e.toString());
    }
  }

  Future<void> onLoadMore() async {
    print('_onLoadMore');
    if (refreshController.isRefresh) {
      refreshController.loadComplete();
      return;
    }
    try {
      await loadNextPage();
      refreshController.loadComplete();
    } on NoMorePage {
      refreshController.loadNoData();
    } on DioError catch (e) {
      refreshController.loadFailed();
      print(e.message);
      BotToast.showText(text: '${I18n.g.network_error}:${e.message}');
    } catch (e) {
      print(e.toString());
      refreshController.loadFailed();
      BotToast.showText(text: e.toString());
    }
  }

  Future<void> launchNewSearch(String tag) async {
    print('launchNewSearch $tag');
    await refreshController.requestRefresh();
    searchText = tag;
    page = 0;
    postList.clear();
  }

  @override
  @action
  Future<void> loadNextPage() async {
    var list = await adapter.postList(
      tags: searchText,
      page: page,
      limit: 50,
    );
    if (settingStore.saveModel) {
      list = list.where((e) => e.rating == PostRating.SAFE).toList();
    }
    if (list.isEmpty) {
      throw NoMorePage();
    }
    postList.addAll(list);
    page += 1;
    print('postList loadNextPage ${postList.length}');
  }

  Future<void> refresh() async {
    print('refresh');
    postList.clear();
    page = 0;
    await loadNextPage();
  }
}
