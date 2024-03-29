import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:catpic/data/database/entity/history.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/basic_search_bar.dart';
import 'package:catpic/ui/components/dark_image.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:catpic/ui/components/fab.dart';
import 'package:catpic/ui/components/load_more_list.dart';
import 'package:catpic/ui/components/load_more_manager.dart';
import 'package:catpic/ui/pages/booru_page/result/booru_result_page.dart';
import 'package:catpic/ui/pages/booru_page/result/pool_result/store/pool_result_store.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class PoolResultFragment extends StatelessWidget {
  PoolResultFragment({
    Key? key,
    required String searchText,
    required this.adapter,
  })  : store = PoolResultStore(
          adapter: adapter,
          searchText: searchText,
        ),
        super(key: key);

  final BooruAdapter adapter;

  final controller = FloatingSearchBarController();
  final PoolResultStore store;

  @override
  Widget build(BuildContext context) {
    return BasicSearchBar(
      historyType: HistoryType.POOL,
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
        itemCount: store.poolList.length,
        itemBuilder: _itemBuilder,
        itemExtent: 100.0,
        cacheExtent: 500,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final pool = store.poolList[index];
    return Card(
      key: ValueKey('Pool${pool.id}'),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BooruPage(
              searchText: 'pool:${pool.id}',
            ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Container(
                width: 60,
                child: DioImage(
                  dio: adapter.dio,
                  builder: () async {
                    await pool.fetchPosts(adapter.client);
                    final booruPost = await pool.fromIndex(adapter.client, 0);
                    return DioImageParams(url: booruPost.getPreviewImg());
                  },
                  errorBuilder:
                      (BuildContext context, Object? err, Function reload) {
                    return InkWell(
                      onTap: () {
                        reload();
                      },
                      child: const Center(
                        child: Icon(Icons.info),
                      ),
                    );
                  },
                  loadingBuilder:
                      (BuildContext context, ImageChunkEvent chunkEvent) {
                    return Container(
                      color: Colors.primaries[index % Colors.primaries.length]
                          [50],
                    );
                  },
                  imageBuilder: (BuildContext context, Uint8List imgData) {
                    return DarkImage(image: MemoryImage(imgData));
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pool.name,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${pool.postCount}P',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                  fontWeight: FontWeight.normal, fontSize: 13),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          pool.createAt,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                  fontWeight: FontWeight.normal, fontSize: 13),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
