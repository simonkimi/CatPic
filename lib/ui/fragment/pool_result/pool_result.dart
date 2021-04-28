import 'dart:ui' as ui;
import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/pull_to_refresh_footer.dart';
import 'package:catpic/ui/fragment/pool_result/pool_preview.dart';
import 'package:catpic/ui/fragment/pool_result/pool_search_bar.dart';
import 'package:catpic/ui/fragment/pool_result/store/pool_result_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PoolResultFragment extends StatefulWidget {
  const PoolResultFragment({
    Key? key,
    this.searchText = '',
    required this.adapter,
  }) : super(key: key);

  final String searchText;
  final BooruAdapter adapter;

  @override
  _PoolResultFragmentState createState() => _PoolResultFragmentState();
}

class _PoolResultFragmentState extends State<PoolResultFragment> {
  late final controller = FloatingSearchBarController();

  late final _store = PoolResultStore(
    searchText: widget.searchText,
    adapter: widget.adapter,
  );

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
          return FloatingSearchBarScrollNotifier(
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
          );
        },
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final pool = _store.observableList[index];
    return Card(
      key: ValueKey('Pool${pool.id}'),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Container(
              width: 60,
              child: PoolPreviewImage(
                client: widget.adapter.client,
                pool: pool,
                index: index,
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
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
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
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
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
    );
  }
}
