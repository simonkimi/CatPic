import 'dart:ui' as ui;
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/data/database/entity/history.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/ui/components/basic_search_bar.dart';
import 'package:catpic/ui/components/load_more_list.dart';
import 'package:catpic/ui/components/load_more_manager.dart';
import 'package:catpic/ui/pages/booru_page/result/artist_result/store/artist_result_store.dart';
import 'package:catpic/ui/components/fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../booru_result_page.dart';

class ArtistResultFragment extends StatelessWidget {
  ArtistResultFragment({
    Key? key,
    required String tag,
    required this.adapter,
  })  : store = ArtistResultStore(
          adapter: adapter,
          searchText: tag,
        ),
        super(key: key);

  final BooruAdapter adapter;

  final controller = FloatingSearchBarController();
  final ArtistResultStore store;

  @override
  Widget build(BuildContext context) {
    return BasicSearchBar(
      historyType: HistoryType.ARTIST,
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
    final artist = store.observableList[index];
    return Card(
      child: ExpansionTile(
        title: Text(artist.name),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              const Icon(Icons.perm_identity, size: 15),
              const SizedBox(width: 5),
              Text(artist.id),
              const SizedBox(width: 20),
              const Icon(Icons.send, size: 15),
              const SizedBox(width: 5),
              Text(artist.urls.length.toString()),
            ],
          ),
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BooruPage(
                        searchText: artist.name,
                      ),
                    ));
                  },
                  child: Text(
                    I18n.of(context).search_in(mainStore.websiteEntity!.name),
                  ),
                ),
              )
            ],
          ),
          ...artist.urls.map((e) {
            return Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      await launch(e);
                    },
                    child: Text(
                      e,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
