import 'dart:io';

import 'package:catpic/network/parser/ehentai/preview_parser.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart' hide Lock;
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:catpic/i18n.dart';
import 'package:synchronized/synchronized.dart';

abstract class ILoadMore<T> {
  ILoadMore(this.searchText) {
    print('Load ILoadMore $searchText');
    onRefresh();
    if (Platform.isWindows) {
      listScrollController.addListener(() {
        if (listScrollController.position.pixels ==
                listScrollController.position.maxScrollExtent &&
            !refreshController.isLoading &&
            !refreshController.isRefresh &&
            (refreshController.footerStatus != LoadStatus.noMore)) {
          refreshController.requestLoading();
        }
      });
    }
  }

  String searchText = '';
  final observableList = ObservableList<T>();
  final refreshController = RefreshController();
  late final ScrollController listScrollController = ScrollController();

  var cancelToken = CancelToken();
  var page = 0;
  var pageTail = 0;

  final lock = Lock();

  String? lastException;

  Future<List<T>> loadPage(int page);

  Future<void> onDataChange();

  int? get pageItemCount;

  bool isLoading = false;

  bool isItemExist(T item);

  Future<void> _loadNextPage() async {
    isLoading = true;
    await lock.synchronized(() async {
      page += 1;
      isLoading = true;
      final list = await loadPage(page);
      final filter = list.where((e) => isItemExist(e) == false);
      observableList.addAll(filter);
      refreshController.loadComplete();
      refreshController.refreshCompleted();
      if (list.isEmpty || (list.length < (pageItemCount ?? 0)))
        refreshController.loadNoData();
      print(
          'LoadMore page: $page length: ${list.length} filter: ${filter.length}');
    });
  }

  Future<void> _loadPreviousPage() async {
    isLoading = true;
    await lock.synchronized(() async {
      pageTail -= 1;
      isLoading = true;
      final list = await loadPage(pageTail);
      final filter = list.where((e) => isItemExist(e) == false);
      observableList.insertAll(0, filter);
      refreshController.loadComplete();
      refreshController.refreshCompleted();
      if (list.isEmpty || (list.length < (pageItemCount ?? 0)))
        refreshController.loadNoData();
    });
  }

  Future<void> onRefresh() async {
    try {
      observableList.clear();
      page = 0;
      await _loadNextPage();
      await onDataChange();
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) return;
      refreshController.loadFailed();
      refreshController.refreshFailed();
      lastException = '${I18n.g.network_error}:${e.message}';
      BotToast.showText(text: lastException!);
      print('onRefresh ${e.message} ${e.requestOptions.path}');
    } on RequireLoginException {
      lastException = I18n.g.requests_login;
    } catch (e) {
      print(e is RequireLoginException);
      refreshController.loadFailed();
      refreshController.refreshFailed();
      print('onRefresh catch ${e.toString()}');
      lastException = e.toString();
      BotToast.showText(text: e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> onLoadMore() async {
    print('onLoadMore');
    if (refreshController.isRefresh || lock.locked) {
      return;
    }
    try {
      await _loadNextPage();
      await onDataChange();
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) return;
      refreshController.loadFailed();
      lastException = '${I18n.g.network_error}:${e.message}';
      BotToast.showText(text: lastException!);
      print('onLoadMore ${e.message} \n ${e.stackTrace}');
    } on RequireLoginException {
      print('RequireLoginException');
      lastException = I18n.g.requests_login;
    } catch (e) {
      print('onLoadMore ${e.toString()}');
      refreshController.loadFailed();
      BotToast.showText(text: e.toString());
      lastException = e.toString();
      refreshController.refreshFailed();
    } finally {
      isLoading = false;
    }
  }

  Future<void> onLoadPrevious() async {
    print('onLoadPrevious');
    if (refreshController.isRefresh || lock.locked) {
      return;
    }
    try {
      if (pageTail < 1) {
        refreshController.refreshCompleted();
        return;
      }
      await _loadPreviousPage();
      await onDataChange();
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) return;
      refreshController.refreshFailed();
      print('onLoadMore ${e.message} \n ${e.stackTrace}');
      lastException = '${I18n.g.network_error}:${e.message}';
      BotToast.showText(text: lastException!);
    } on RequireLoginException {
      lastException = I18n.g.requests_login;
      print('RequireLoginException');
      refreshController.refreshFailed();
    } catch (e) {
      print('onLoadMore ${e.toString()}');
      refreshController.refreshFailed();
      BotToast.showText(text: e.toString());
      lastException = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> onNewSearch(String tag) async {
    print('onNewSearch $tag');
    if (lock.locked) {
      cancelToken.cancel();
      cancelToken = CancelToken();
      await lock.synchronized(() {});
    }
    isLoading = true;
    searchText = tag;
    page = 0;
    observableList.clear();
    await onRefresh();
    await onDataChange();
  }

  Future<void> onJumpPage(int newPage) async {
    print('onJumpPage');
    page = newPage - 1;
    pageTail = newPage - 1;
    observableList.clear();
    await onLoadMore();
  }
}
