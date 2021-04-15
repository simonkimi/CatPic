import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/exception/no_more_page.dart';
import 'package:catpic/data/interface/post_view.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/store/main/main_store.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:dio/dio.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'post_result_store.g.dart';

class PostResultStore = PostResultStoreBase with _$PostResultStore;

abstract class PostResultStoreBase with Store implements PostViewInterface {
  PostResultStoreBase({
    required this.searchText,
    required this.adapter,
  });

  final BooruAdapter adapter;

  @override
  String searchText;

  var postList = ObservableList<BooruPost>();
  var page = 0;
  final refreshController = RefreshController(initialRefresh: true);

  Future<void> onRefresh() async {
    print('_onRefresh');
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
      // BotToast.showText(text: '${S.of(context).network_error}:${e.message}');
      print(e.message);
    } catch (e) {
      print(e.toString());
      refreshController.loadFailed();
      refreshController.refreshFailed();
      // BotToast.showText(text: e.toString());
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
      // BotToast.showText(text: '${S.of(context).network_error}:${e.message}');
    } catch (e) {
      print(e.toString());
      refreshController.loadFailed();
      // BotToast.showText(text: e.toString());
    }
  }

  Future<void> launchNewSearch(String tag) async {
    await refreshController.requestRefresh();
    searchText = tag;
    page = 0;
    postList.clear();
  }


  @override
  @action
  Future<void> loadNextPage() async {
    final list =
        await adapter.postList(tags: searchText, page: page, limit: 50);
    if (list.isEmpty) {
      throw NoMorePage();
    }
    postList.addAll(list);
    page += 1;
    print('postList loadNextPage ${postList.length}');
  }

  Future<void> refresh() async {
    postList.clear();
    page = 0;
    await loadNextPage();
  }
}
