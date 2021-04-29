import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:catpic/i18n.dart';

class NoMorePage implements Exception {}

abstract class ILoadMore<T> {
  ILoadMore(this.searchText) {
    onRefresh();
  }

  String searchText = '';
  final observableList = ObservableList<T>();
  final refreshController = RefreshController();
  var page = 0;
  bool isLoading = false;

  Future<List<T>> onLoadNextPage();

  Future<void> onDataChange();

  Future<void> loadNextPage() async {
    final list = await onLoadNextPage();
    if (list.isEmpty) {
      throw NoMorePage();
    }
    page += 1;
    observableList.addAll(list);
    print('loadNextPage ${list.length}');
  }

  Future<void> onRefresh() async {
    print('onRefresh');
    if (isLoading) return;
    try {
      isLoading = true;
      observableList.clear();
      page = 0;
      await loadNextPage();
      await onDataChange();
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

  Future<void> onLoadMore() async {
    print('onLoadMore current page: $page');
    if (refreshController.isRefresh) {
      refreshController.loadComplete();
      return;
    }
    try {
      await loadNextPage();
      await onDataChange();
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

  Future<void> onNewSearch(String tag) async {
    print('onNewSearch $tag');
    await refreshController.requestRefresh();
    searchText = tag;
    page = 0;
    observableList.clear();
    await onDataChange();
  }
}
