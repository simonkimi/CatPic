import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart' hide Lock;
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:catpic/i18n.dart';
import 'package:synchronized/synchronized.dart';

abstract class ILoadMore<T> {
  ILoadMore(this.searchText) {
    onRefresh();
  }

  String searchText = '';
  final observableList = ObservableList<T>();
  final refreshController = RefreshController();
  final listScrollController = ScrollController();
  final cancelToken = CancelToken();
  var page = 0;

  final lock = Lock();

  Future<List<T>> onLoadNextPage();

  Future<void> onDataChange();

  int? get pageItemCount;

  bool isLoading = false;

  Future<void> _loadNextPage() async {
    isLoading = true;
    await lock.synchronized(() async {
      page += 1;
      final list = await onLoadNextPage();
      observableList.addAll(list);
      refreshController.loadComplete();
      refreshController.refreshCompleted();
      if (list.isEmpty || (list.length < (pageItemCount ?? 0)))
        refreshController.loadNoData();
      print('loadNextPage ${page - 1} ${list.length}');
    });
  }

  Future<void> onRefresh() async {
    if (lock.locked) return;
    try {
      observableList.clear();
      page = 0;
      await _loadNextPage();
      await onDataChange();
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) return;
      refreshController.loadFailed();
      refreshController.refreshFailed();
      BotToast.showText(text: '${I18n.g.network_error}:${e.message}');
      print('onRefresh ${e.message} ${e.requestOptions.path}');
    } catch (e) {
      print('onRefresh ${e.toString()}');
      refreshController.loadFailed();
      refreshController.refreshFailed();
      BotToast.showText(text: e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> onLoadMore() async {
    if (refreshController.isRefresh || lock.locked) {
      refreshController.loadComplete();
      return;
    }
    print('onLoadMore current page: $page');
    await _loadNextPage();
    await onDataChange();
    try {
      await _loadNextPage();
      await onDataChange();
      refreshController.loadComplete();
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) return;
      refreshController.loadFailed();
      print('onLoadMore ${e.message} \n ${e.stackTrace}');
      BotToast.showText(text: '${I18n.g.network_error}:${e.message}');
    } catch (e) {
      print('onLoadMore ${e.toString()}');
      refreshController.loadFailed();
      BotToast.showText(text: e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> onNewSearch(String tag) async {
    print('onNewSearch $tag');
    if (lock.locked) cancelToken.cancel();
    searchText = tag;
    page = 0;
    observableList.clear();
    await onRefresh();
    await onDataChange();
  }

  Future<void> onJumpPage(int newPage) async {
    page = newPage - 1;
    observableList.clear();
    await onLoadMore();
  }
}
