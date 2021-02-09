import 'dart:ui';

import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/cached_image.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'post_result_store.dart';

typedef ValueCallBack = void Function(String);

class PostResultFragment extends StatefulWidget {
  const PostResultFragment({
    Key key,
    this.searchText = '',
    @required this.adapter,
    @required this.onSearch,
  }) : super(key: key);

  final String searchText;
  final BooruAdapter adapter;
  final ValueCallBack onSearch;

  @override
  _PostResultFragmentState createState() => _PostResultFragmentState();
}

mixin _PostResultFragmentMixin<T extends StatefulWidget> on State<T> {
  final _searchBarController = FloatingSearchBarController();
  final _refreshController = RefreshController(initialRefresh: false);

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
      onSubmitted: (value) {
        widget.onSearch(value);
      },
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.filter_alt_outlined),
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
    final post = _store.postList[index];
    return PostPreviewCard(
      key: Key('item${post.id}'),
      title: '# ${post.id}',
      subTitle: '${post.width} x ${post.height}',
      body: CachedDioImage(
        dio: widget.adapter.dio,
        imgUrl: post.previewURL,
        imageBuilder: (context, imgData) {
          return Image(image: MemoryImage(imgData, scale: 0.1));
        },
        loadingBuilder: (_, progress) {
          return AspectRatio(
            aspectRatio: post.width / post.height,
            child: Center(
              child: CircularProgressIndicator(
                value: ((progress.expectedTotalBytes ?? 0) != 0) &&
                        ((progress.cumulativeBytesLoaded ?? 0) != 0)
                    ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes
                    : 0.0,
              ),
            ),
          );
        },
        errorBuilder: (_, err) {
          return AspectRatio(
            aspectRatio: post.width / post.height,
            child: Text('Fail ${err.toString()}'),
          );
        },
      ),
    );
  }

  Widget buildWaterFlow() {
    final height = MediaQueryData.fromWindow(window).padding.top;
    return FloatingSearchBarScrollNotifier(
      child: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        controller: _refreshController,
        header: MaterialClassicHeader(
          distance: height + 80,
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoadMore,
        child: WaterfallFlow.builder(
          padding: EdgeInsets.only(top: 60 + height),
          gridDelegate:
              const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
          itemCount: _store.postList.length,
          itemBuilder: _itemBuilder,
        ),
      ),
    );
  }
}