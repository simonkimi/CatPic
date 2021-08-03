import 'dart:ui' as ui;

import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/network/api/ehentai/eh_filter.dart';
import 'package:catpic/ui/components/load_more_list.dart';
import 'package:catpic/ui/components/load_more_manager.dart';
import 'package:catpic/ui/pages/eh_page/components/eh_complete_bar.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_extended_card/preview_extended_card.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_index_card/preview_index_card.dart';
import 'package:catpic/ui/pages/eh_page/index_page/store/store.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../../../main.dart';

class EhIndexResult extends StatelessWidget {
  EhIndexResult({
    Key? key,
    this.searchText = '',
    required this.adapter,
    EhAdvanceFilter? baseFilter,
  })  : store = EhIndexStore(
          adapter: adapter,
          searchText: searchText,
          baseFilter: baseFilter,
        ),
        super(key: key);

  final String searchText;
  final EHAdapter adapter;
  final EhIndexStore store;

  final retryList = <Function>[];

  @override
  Widget build(BuildContext context) {
    return EhCompleteBar(
      searchText: searchText,
      store: store,
      onSubmitted: (value, useFilter, _) {
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

  Widget buildWaterFlow() {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return LoadMoreList(
        store: store,
        body: WaterfallFlow.builder(
          gridDelegate: SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            maxCrossAxisExtent: CardSize.of(settingStore.cardSize).toDouble(),
          ),
          cacheExtent: 500,
          controller: store.listScrollController,
          padding: EdgeInsets.only(top: 60 + barHeight, left: 10, right: 10),
          itemCount: store.observableList.length,
          itemBuilder: (context, index) {
            if (index >= store.observableList.length) return const SizedBox();
            final item = store.observableList[index];
            return PreviewIndexCard(
                index: index,
                previewModel: item,
                adapter: adapter,
                onTap: () {
                  DB()
                      .galleryHistoryDao
                      .add(EhGalleryHistoryTableCompanion.insert(
                        gid: item.gid,
                        gtoken: item.gtoken,
                        pb: item.writeToBuffer(),
                      ));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return EhPreviewPage(
                          previewAspectRatio:
                              item.previewHeight / item.previewWidth,
                          previewModel: item,
                          heroTag: '${item.gid}${item.gtoken}',
                          adapter: adapter,
                        );
                      },
                    ),
                  );
                });
          },
        ));
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
        itemBuilder: (BuildContext context, int index) {
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
                      previewAspectRatio:
                          item.previewHeight / item.previewWidth,
                      previewModel: item,
                      heroTag: '${item.gid}${item.gtoken}',
                      adapter: adapter,
                    );
                  },
                ),
              );
            },
            onLoadError: (retry) {
              retryList.add(retry);
            },
            onRetryTap: () {
              for (final func in retryList) func();
              retryList.clear();
            },
          );
        },
      ),
    );
  }
}
