import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/main.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:catpic/i18n.dart';

part 'post_result_store.g.dart';

class PostResultStore = PostResultStoreBase with _$PostResultStore;

class NoMorePage implements Exception {}

abstract class PostResultStoreBase extends ILoadMore<BooruPost> with Store {
  PostResultStoreBase({
    String searchText = '',
    required this.adapter,
  }) : super(searchText) {
    onRefresh();
  }

  final BooruAdapter adapter;

  @observable
  bool isLoading = false;

  @computed
  List<BooruPost> get postList {
    if (settingStore.saveModel) {
      return list.where((e) => e.rating == PostRating.SAFE).toList();
    }
    return list;
  }

  var page = 0;
  final refreshController = RefreshController();

  @override
  Future<void> onRefresh() async {
    print('onRefresh');
    if (isLoading) return;
    try {
      isLoading = true;
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
      print('onRefresh ${e.message}');
    } catch (e) {
      print('onRefresh ${e.toString()}');
      refreshController.loadFailed();
      refreshController.refreshFailed();
      BotToast.showText(text: e.toString());
    }
    isLoading = false;
  }

  @override
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
      print('onLoadMore ${e.message}');
      BotToast.showText(text: '${I18n.g.network_error}:${e.message}');
    } catch (e) {
      print('onLoadMore ${e.toString()}');
      refreshController.loadFailed();
      BotToast.showText(text: e.toString());
    }
  }

  Future<void> launchNewSearch(String tag) async {
    print('launchNewSearch $tag');
    await refreshController.requestRefresh();
    searchText = tag;
    page = 0;
    list.clear();
  }

  @action
  Future<void> loadNextPage() async {
    final list = await adapter.postList(
      tags: searchText,
      page: page,
      limit: 50,
    );
    if (list.isEmpty) {
      throw NoMorePage();
    }
    list.addAll(list);
    page += 1;
    print('postList loadNextPage ${list.length}');
  }

  Future<void> refresh() async {
    print('refresh');
    list.clear();
    page = 0;
    await loadNextPage();
  }
}
