import 'dart:ui' as ui;

import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/components/pull_to_refresh_footer.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_extended_card/preview_extended_card.dart';
import 'package:catpic/ui/pages/eh_page/index_page/store/store.dart';
import 'package:catpic/ui/pages/booru_page/result/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../i18n.dart';
import '../../../../main.dart';

class EhIndexResult extends StatelessWidget {
  EhIndexResult({
    Key? key,
    this.searchText = '',
    required this.adapter,
  })  : store = EhIndexStore(
          adapter: adapter,
          searchText: searchText,
        ),
        super(key: key);

  final String searchText;
  final EHAdapter adapter;
  final EhIndexStore store;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Scaffold.of(context).isDrawerOpen) {
          return true;
        }
        final nowTime = DateTime.now();
        if (mainStore.searchPageCount <= 1 &&
            nowTime.difference(store.lastClickBack) >
                const Duration(seconds: 2)) {
          BotToast.showText(text: I18n.of(context).click_again_to_exit);
          store.lastClickBack = nowTime;
          return false;
        }
        return true;
      },
      child: SearchBar(
        searchText: searchText,
        onSubmitted: (value) {
          store.newSearch(value);
        },
        body: buildBody(),
        candidateBuilder: (BuildContext context, Animation<double> transition) {
          return const SizedBox();
        },
      ),
    );
  }

  AnimatedSwitcher buildBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1),
      child: Observer(builder: (_) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: store.observableList.isEmpty &&
                  (store.isLoading || store.lock.locked)
              ? LoadingWidget(store: store)
              : buildList(),
        );
      }),
    );
  }

  Widget buildList() {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return Scrollbar(
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
            controller: store.listScrollController,
            padding: EdgeInsets.only(top: 60 + barHeight, left: 10, right: 10),
            itemCount: store.observableList.length,
            itemBuilder: _itemBuilder,
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
