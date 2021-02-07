import 'dart:math';

import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/cached_image.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'dart:ui';
import 'post_result_store.dart';

class PostResultFragment extends StatefulWidget {
  final String searchText;
  final BooruAdapter adapter;

  PostResultFragment({Key key, this.searchText, this.adapter})
      : super(key: key);

  @override
  _PostResultFragmentState createState() => _PostResultFragmentState();
}

mixin _PostResultFragmentMixin<T extends StatefulWidget> on State<T> {
  var _searchBarController = FloatingSearchBarController();
  var _refreshController = RefreshController(initialRefresh: false);

  PostResultStore _store;

  Future<void> _onRefresh() async {
    try {
      await _store.refresh();
      _refreshController.loadComplete();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.loadFailed();
      _refreshController.refreshFailed();
    }
  }

  Future<void> _onLoadMore() async {
    try {
      await _store.loadNextPage();
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }
}

class _PostResultFragmentState extends State<PostResultFragment>
    with _PostResultFragmentMixin {
  @override
  Widget build(BuildContext context) {
    _store =
        PostResultStore(searchText: widget.searchText, adapter: widget.adapter);
    _store.loadNextPage();
    return Observer(
      builder: (_) => _buildSearchBar(),
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      controller: _searchBarController,
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      body: buildWaterFlow(),
      candidateBuilder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _itemBuilder(BuildContext ctx, int index) {
    var post = _store.postList[index];
    var color = Colors.accents[Random().nextInt(Colors.accents.length)][100];
    return PostPreviewCard(
      key: Key('item${post.id}'),
      title: '# ${post.id}',
      subTitle: '${post.width} x ${post.height}',

      body: CachedDioImage(
        imgUrl: post.previewURL,
        dio: widget.adapter.dio,
        cachedKey: post.md5,
        imageBuilder: (_, imgProvider) => Container(
          width: post.previewWidth.toDouble(),
          height: post.previewHeight.toDouble(),
          color: color,
        ),
        errorBuilder: (_, err) => Container(
          width: post.previewWidth.toDouble(),
          height: post.previewHeight.toDouble(),
          color: color,
          child: Center(
            child: Text(err.toString()),
          ),
        ),
        loadingBuilder: (context, total, received, progress) {
          return Container(
            width: post.previewWidth.toDouble(),
            height: post.previewHeight.toDouble(),
            color: color,
            child: Center(
              child: Text('${(progress * 100).toInt()}%'),
            ),
          );
        },
      ),
    );
  }

  Widget buildWaterFlow() {
    var height = MediaQueryData.fromWindow(window).padding.top;
    return FloatingSearchBarScrollNotifier(
      child: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        controller: _refreshController,
        header: MaterialClassicHeader(
          distance: 90,
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoadMore,
        child: WaterfallFlow.builder(
          padding: EdgeInsets.only(top: 60 + height),
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
          itemCount: _store.postList.length,
          itemBuilder: _itemBuilder,
        ),
      ),
    );
  }
}
