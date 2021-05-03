import 'dart:ui' as ui;
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/data/database/entity/history.dart';
import 'package:catpic/ui/components/basic_search_bar.dart';
import 'package:catpic/ui/components/pull_to_refresh_footer.dart';
import 'package:catpic/ui/pages/search_page/fragment/loading/loading.dart';
import 'package:catpic/ui/pages/search_page/fragment/tag_result/store/tag_result_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';

import '../../search_page.dart';

class TagResultFragment extends StatelessWidget {
  TagResultFragment({
    Key? key,
    this.searchText = '',
    required this.adapter,
    required this.store,
  }) : super(key: key);

  final String searchText;
  final BooruAdapter adapter;

  final controller = FloatingSearchBarController();
  final TagResultStore store;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (store.lock.locked) {
        store.refreshController.requestRefresh();
      }
    });

    return BasicSearchBar(
      historyType: HistoryType.TAG,
      onSearch: (value) {
        store.onNewSearch(value.trim());
      },
      body: Observer(
        builder: (_) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: store.isLoading ? LoadingWidget(store: store) : buildList(),
          );
        },
      ),
    );
  }

  Scrollbar buildList() {
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
            padding: EdgeInsets.only(top: 60 + barHeight, left: 3, right: 3),
            itemCount: store.observableList.length,
            itemBuilder: _itemBuilder,
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final tag = store.observableList[index];
    return Card(
      child: ListTile(
        title: Text(tag.name),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                tag.type.string,
                style: TextStyle(color: tag.type.color),
              ),
            ),
            Text(
              tag.count.toString(),
              style: Theme.of(context).textTheme.subtitle2,
            )
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchPage(
              searchText: tag.name,
            ),
          ));
        },
      ),
    );
  }
}
