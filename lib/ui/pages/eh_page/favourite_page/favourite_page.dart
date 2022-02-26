import 'dart:ui' as ui;

import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/gen/eh_storage.pb.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/components/load_more_list.dart';
import 'package:catpic/ui/components/load_more_manager.dart';
import 'package:catpic/ui/fragment/main_drawer/main_drawer.dart';
import 'package:catpic/ui/pages/eh_page/components/eh_complete_bar.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_extended_card/preview_extended_card.dart';
import 'package:catpic/ui/pages/eh_page/eh_page.dart';
import 'package:catpic/ui/pages/eh_page/favourite_page/store/store.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class EhFavouritePage extends StatefulWidget {
  const EhFavouritePage({Key? key}) : super(key: key);

  @override
  _EhFavouritePageState createState() => _EhFavouritePageState();
}

class _EhFavouritePageState extends State<EhFavouritePage> {
  final adapter = mainStore.adapter! as EHAdapter;
  late final store = EhFavouriteStore(
    adapter: adapter,
    searchText: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: 200,
      drawer: const MainDrawer(
        ehSearchType: EHSearchType.FAVOURITE,
      ),
      endDrawer: buildEndDrawer(),
      body: EhCompleteBarWithoutFilter(
        searchText: '',
        onSubmitted: (value) {
          store.onNewSearch(value.trim());
        },
        body: Observer(
          builder: (_) {
            return LoadMoreManager(
              store: store,
              body: buildList(),
            );
          },
        ),
      ),
    );
  }

  Widget buildEndDrawer() {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return SizedBox(
      width: 250,
      child: Padding(
        padding: EdgeInsets.only(top: barHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Drawer(
            child: Column(
              children: [
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 15),
                      Text(
                        I18n.of(context).favourite_box,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Observer(
                  builder: (_) {
                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        EhFavourite(
                            tag: I18n.of(context).favourite_all,
                            favcat: -1,
                            count: adapter.websiteEntity.favouriteList
                                .fold<int>(
                                    0,
                                    (previousValue, element) =>
                                        previousValue + element.count)),
                        ...adapter.websiteEntity.favouriteList
                      ]
                          .map((e) => InkWell(
                                onTap: () {
                                  store.changeSearchCat(e.favcat);
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: Colors.black12,
                                    width: 0.5,
                                  ))),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Text(e.tag),
                                      const Expanded(child: SizedBox()),
                                      Text(e.count.toString()),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList() {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return LoadMoreList(
      store: store,
      body: ListView.builder(
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
    final heroTag = 'favourite${item.gid}${item.gtoken}';
    return PreviewExtendedCard(
      previewModel: item,
      adapter: adapter,
      heroTag: heroTag,
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
                heroTag: heroTag,
                adapter: adapter,
              );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    mainStore.addSearchPage();
  }

  @override
  void dispose() {
    super.dispose();
    mainStore.descSearchPage();
  }
}
