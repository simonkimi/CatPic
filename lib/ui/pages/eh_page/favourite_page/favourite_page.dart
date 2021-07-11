import 'dart:ui' as ui;
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/components/load_more_list.dart';
import 'package:catpic/ui/components/load_more_manager.dart';
import 'package:catpic/ui/fragment/main_drawer/main_drawer.dart';
import 'package:catpic/ui/pages/eh_page/components/eh_complete_bar.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_extended_card/preview_extended_card.dart';
import 'package:catpic/ui/pages/eh_page/eh_page.dart';
import 'package:catpic/ui/pages/eh_page/favourite_page/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class EhFavouritePage extends StatefulWidget {
  const EhFavouritePage({Key? key}) : super(key: key);

  @override
  _EhFavouritePageState createState() => _EhFavouritePageState();
}

class _EhFavouritePageState extends State<EhFavouritePage> {
  final adapter = EHAdapter(mainStore.websiteEntity!);
  late final store = EhFavouriteStore(
    adapter: adapter,
    searchText: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return const Drawer();
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
    return PreviewExtendedCard(
      previewModel: item,
      adapter: adapter,
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
