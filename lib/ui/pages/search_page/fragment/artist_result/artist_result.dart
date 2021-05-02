import 'dart:ui' as ui;
import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/database/entity/history.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/ui/components/basic_search_bar.dart';
import 'package:catpic/ui/components/pull_to_refresh_footer.dart';
import 'package:catpic/ui/pages/search_page/fragment/artist_result/store/artist_result_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../search_page.dart';

class ArtistResultFragment extends StatelessWidget {
  ArtistResultFragment({
    Key? key,
    this.searchText = '',
    required this.adapter,
  })   : _store = ArtistResultStore(
          searchText: searchText,
          adapter: adapter,
        ),
        super(key: key);

  final String searchText;
  final BooruAdapter adapter;

  final controller = FloatingSearchBarController();
  final ArtistResultStore _store;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_store.lock.locked) {
        _store.refreshController.requestRefresh();
      }
    });
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return BasicSearchBar(
      historyType: HistoryType.ARTIST,
      onSearch: (value) {
        _store.onNewSearch(value.trim());
      },
      body: Observer(
        builder: (_) {
          return Scrollbar(
            showTrackOnHover: true,
            child: FloatingSearchBarScrollNotifier(
              child: SmartRefresher(
                enablePullUp: true,
                enablePullDown: true,
                footer: CustomFooter(
                  builder: buildFooter,
                ),
                controller: _store.refreshController,
                header: MaterialClassicHeader(
                  distance: barHeight + 70,
                  height: barHeight + 80,
                ),
                onRefresh: _store.onRefresh,
                onLoading: _store.onLoadMore,
                child: ListView.builder(
                  padding:
                      EdgeInsets.only(top: 60 + barHeight, left: 3, right: 3),
                  itemCount: _store.observableList.length,
                  itemBuilder: _itemBuilder,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final artist = _store.observableList[index];
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
                      builder: (context) => SearchPage(
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
