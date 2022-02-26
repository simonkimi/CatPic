import 'dart:ui' as ui;

import 'package:catpic/data/database/entity/history.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/basic_search_bar.dart';
import 'package:catpic/ui/components/fab.dart';
import 'package:catpic/ui/components/load_more_list.dart';
import 'package:catpic/ui/components/load_more_manager.dart';
import 'package:catpic/ui/pages/booru_page/result/tag_result/store/tag_result_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../booru_result_page.dart';

class TagResultFragment extends StatelessWidget {
  TagResultFragment({
    Key? key,
    this.searchText = '',
    required this.adapter,
  })  : store = TagResultStore(
          adapter: adapter,
          searchText: searchText,
        ),
        super(key: key);

  final String searchText;
  final BooruAdapter adapter;

  final controller = FloatingSearchBarController();
  final TagResultStore store;

  @override
  Widget build(BuildContext context) {
    return BasicSearchBar(
      historyType: HistoryType.TAG,
      onSearch: (value) {
        store.onNewSearch(value.trim());
      },
      body: Scaffold(
        body: Observer(
          builder: (_) {
            return LoadMoreManager(
              store: store,
              body: buildList(),
            );
          },
        ),
        floatingActionButton: FloatActionBubble(loadMoreStore: store),
      ),
    );
  }

  Widget buildList() {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return LoadMoreList(
      store: store,
      body: ListView.builder(
        controller: store.listScrollController,
        padding: EdgeInsets.only(top: 60 + barHeight, left: 3, right: 3),
        itemCount: store.observableList.length,
        itemBuilder: _itemBuilder,
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
            builder: (context) => BooruPage(
              searchText: tag.name,
            ),
          ));
        },
      ),
    );
  }
}
