import 'dart:ui' as ui;

import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/components/load_more_list.dart';
import 'package:catpic/ui/components/load_more_manager.dart';
import 'package:catpic/ui/pages/eh_page/components/eh_complete_bar.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_extended_card/preview_extended_card.dart';
import 'package:catpic/ui/pages/eh_page/index_page/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
    return EhCompleteBar(
      searchText: searchText,
      store: store,
      onSubmitted: (value, useFilter) {
        store.applyNewFilter(value.trim(), useFilter);
      },
      body: Observer(
        builder: (_) {
          return LoadMoreManager(
            store: store,
            body: buildList(),
          );
        },
      ),
    );
  }

  Widget buildList() {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return LoadMoreList(
      store: store,
      body: ListView.builder(
        cacheExtent: 500,
        controller: store.listScrollController,
        padding: EdgeInsets.only(top: 60 + barHeight, left: 10, right: 10),
        itemCount: store.observableList.length,
        itemBuilder: _itemBuilder,
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
