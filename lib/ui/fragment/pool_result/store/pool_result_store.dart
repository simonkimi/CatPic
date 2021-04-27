import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:catpic/i18n.dart';

part 'pool_result_store.g.dart';

class PoolResultStore = PoolResultStoreBase with _$PoolResultStore;

abstract class PoolResultStoreBase extends ILoadMore<BooruPool> with Store {
  PoolResultStoreBase({
    String searchText = '',
    required this.adapter,
  }) : super(searchText) {
    onRefresh();
  }

  final BooruAdapter adapter;

  @observable
  bool isLoading = false;

  final refreshController = RefreshController();

  @override
  Future<void> onRefresh() async {
    print('onRefresh');
    if (isLoading) return;
    try {
      observableList.clear();
      page = 0;
      await loadNextPage();
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

  @action
  Future<void> loadNextPage() async {
    final list = await adapter.poolList(
      name: searchText,
      page: page,
    );
    if (list.isEmpty) {
      throw NoMorePage();
    }
    observableList.addAll(list);
    page += 1;
    print('postList loadNextPage ${list.length}');
  }
}
