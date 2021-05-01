import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:catpic/ui/components/pull_to_refresh_footer.dart';
import 'package:catpic/ui/pages/pool_preview_page/pool_preview_page.dart';
import 'package:catpic/ui/pages/search_page/fragment/pool_result/pool_search_bar.dart';
import 'package:catpic/ui/pages/search_page/fragment/pool_result/store/pool_result_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PoolResultFragment extends StatelessWidget {
  PoolResultFragment({
    Key? key,
    this.searchText = '',
    required this.adapter,
  })   : _store = PoolResultStore(
          searchText: searchText,
          adapter: adapter,
        ),
        super(key: key);

  final String searchText;
  final BooruAdapter adapter;

  final controller = FloatingSearchBarController();
  final PoolResultStore _store;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_store.isLoading) {
        _store.refreshController.requestRefresh();
      }
    });
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return PoolSearchBar(
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
                  itemExtent: 100.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final pool = _store.observableList[index];
    return Card(
      key: ValueKey('Pool${pool.id}'),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PoolPreviewPage(
              booruPool: pool,
              adapter: adapter,
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
                  imageUrlBuilder: () async {
                    await pool.fetchPosts(adapter.client);
                    return (await pool.fromIndex(adapter.client, 0))
                        .getPreviewImg();
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
                    return Image(image: MemoryImage(imgData));
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
