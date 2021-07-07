import 'dart:ui' as ui;
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/components/fab.dart';
import 'package:catpic/ui/components/pull_to_refresh_footer.dart';
import 'package:catpic/ui/pages/booru_page/result/loading/loading.dart';
import 'package:catpic/ui/pages/eh_page/components/eh_complete_bar.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_extended_card/preview_extended_card.dart';
import 'package:catpic/ui/pages/eh_page/watched_page/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EhWatchedResult extends StatelessWidget {
  EhWatchedResult({
    Key? key,
    this.searchText = '',
    required this.adapter,
  })  : store = EhWatchedStore(
          adapter: adapter,
          searchText: searchText,
        ),
        super(key: key);

  final String searchText;
  final EHAdapter adapter;
  final EhWatchedStore store;

  @override
  Widget build(BuildContext context) {
    return EhCompleteBar(
      searchText: searchText,
      store: store,
      onSubmitted: (value, useFilter) {
        store.applyNewFilter(value.trim(), useFilter);
      },
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1),
      child: Observer(builder: (_) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: () {
            if (store.isLoading && store.observableList.isEmpty)
              return const Center(child: CircularProgressIndicator());
            if (store.observableList.isEmpty) return EmptyWidget(store: store);
            return buildList();
          }(),
        );
      }),
    );
  }

  Widget buildList() {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return Scaffold(
      floatingActionButton: FloatActionBubble(loadMoreStore: store),
      body: Scrollbar(
        showTrackOnHover: true,
        child: FloatingSearchBarScrollNotifier(
          child: SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            footer: CustomFooter(
              builder: buildFooter,
            ),
            controller: store.refreshController,
            header: MaterialClassicHeader(
              distance: barHeight + 70,
              height: barHeight + 80,
            ),
            onRefresh: store.onRefresh,
            onLoading: store.onLoadMore,
            child: ListView.builder(
              cacheExtent: 500,
              controller: store.listScrollController,
              padding:
                  EdgeInsets.only(top: 60 + barHeight, left: 10, right: 10),
              itemCount: store.observableList.length,
              itemBuilder: _itemBuilder,
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index >= store.observableList.length) return const SizedBox();
    final item = store.observableList[index];
    return PreviewExtendedCard(
      previewModel: item,
      adapter: adapter,
    );
  }
}
