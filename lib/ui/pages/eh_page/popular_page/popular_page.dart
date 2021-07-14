import 'dart:ui' as ui;

import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/components/load_more_list.dart';
import 'package:catpic/ui/components/load_more_manager.dart';
import 'package:catpic/ui/pages/eh_page/components/eh_complete_bar.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_extended_card/preview_extended_card.dart';
import 'package:catpic/ui/pages/eh_page/eh_page.dart';
import 'package:catpic/ui/pages/eh_page/popular_page/store/store.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class EhPopularResult extends StatelessWidget {
  EhPopularResult({
    Key? key,
    required this.adapter,
  })  : store = EhPopularResultStore(adapter),
        super(key: key);

  final EHAdapter adapter;
  final EhPopularResultStore store;

  @override
  Widget build(BuildContext context) {
    return EhCompleteBar(
      searchText: '',
      store: store,
      onSubmitted: (value, useFilter, filter) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return EhPage(
            searchText: value.trim(),
            searchType: EHSearchType.INDEX,
            baseFilter: filter,
          );
        }));
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
      enablePullUp: false,
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
      onTap: () {
        DB().galleryHistoryDao.add(EhGalleryHistoryTableCompanion.insert(
              gid: item.gid,
              gtoken: item.gtoken,
              pb: item.writeToBuffer(),
            ));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return EhPreviewPage(
                previewAspectRatio: item.previewHeight / item.previewWidth,
                previewModel: item,
                heroTag: '${item.gid}${item.gtoken}',
                adapter: adapter,
              );
            },
          ),
        );
      },
    );
  }
}
