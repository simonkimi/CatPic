import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/exception/no_more_page.dart';
import 'package:catpic/generated/l10n.dart';
import 'package:catpic/ui/components/cached_image.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/pages/image_view_page/image_view_page.dart';
import 'package:catpic/ui/store/main/main_store.dart';
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
  }) : super(key: key);

  final String searchText;
  final BooruAdapter adapter;

  @override
  _PostResultFragmentState createState() => _PostResultFragmentState();
}

mixin _PostResultFragmentMixin<T extends StatefulWidget> on State<T> {
  final _searchBarController = FloatingSearchBarController();
  final _refreshController = RefreshController(initialRefresh: false);

  PostResultStore _store;

  Future<void> _onRefresh() async {
    print('_onRefresh');
    try {
      await _store.refresh();
      _refreshController.loadComplete();
      _refreshController.refreshCompleted();
    } on NoMorePage {
      _refreshController.loadNoData();
    } catch (e) {
      _refreshController.loadFailed();
      _refreshController.refreshFailed();
      BotToast.showText(text: e.toString());
    }
  }

  Future<void> _onLoadMore() async {
    print('_onLoadMore');
    if (_refreshController.isRefresh) {
      _refreshController.loadComplete();
      return;
    }
    try {
      await _store.loadNextPage();
      _refreshController.loadComplete();
    } on NoMorePage {
      _refreshController.loadNoData();
    } on Error catch (e) {
      print(e.stackTrace);
      _refreshController.loadFailed();
      BotToast.showText(text: e.toString());
    }
  }

  Future<void> _newSearch(String tag) async {
    await _store.launchNewSearch(tag);
    await _refreshController.requestRefresh();
  }
}

class _PostResultFragmentState extends State<PostResultFragment>
    with _PostResultFragmentMixin {
  @override
  void initState() {
    super.initState();
    _store =
        PostResultStore(searchText: widget.searchText, adapter: widget.adapter);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshController.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => _buildSearchBar(),
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      controller: _searchBarController,
      defaultHint: widget.searchText.isNotEmpty ? widget.searchText : 'CatPic',
      onSubmitted: (value) {
        _newSearch(value);
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

    final loadDetail = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewPage(
            dio: mainStore.websiteEntity.getAdapter().dio,
            booruPost: post,
            heroTag: '${post.id}|${post.md5}',
          ),
        ),
      );
    };

    return PostPreviewCard(
      key: Key('item${post.id}${post.md5}'),
      title: '# ${post.id}',
      subTitle: '${post.width} x ${post.height}',
      body: CachedDioImage(
        dio: widget.adapter.dio,
        imgUrl: post.previewURL,
        imageBuilder: (context, imgData) {
          return InkWell(
            onTap: loadDetail,
            child: Hero(
              tag: '${post.id}|${post.md5}',
              child: Image(image: MemoryImage(imgData, scale: 0.1)),
            ),
          );
        },
        loadingBuilder: (_, progress) {
          return GestureDetector(
            onTap: loadDetail,
            child: AspectRatio(
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
            ),
          );
        },
        errorBuilder: (_, err, reload) {
          return GestureDetector(
            onTap: () {
              reload();
            },
            child: AspectRatio(
              aspectRatio: post.width / post.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.error),
                  SizedBox(
                    height: 10,
                  ),
                  Text('点击重新加载'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context, LoadStatus status) {
    Widget buildRow(List<Widget> children) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      );
    }

    switch (status) {
      case LoadStatus.idle:
        return buildRow([
          const Icon(Icons.arrow_upward),
          const SizedBox(
            width: 10,
          ),
          Text(
            S.of(context).idle_loading,
            style: const TextStyle(color: Colors.black),
          ),
        ]);
        break;
      case LoadStatus.canLoading:
        return buildRow([
          const Icon(Icons.arrow_downward),
          const SizedBox(
            width: 10,
          ),
          Text(
            S.of(context).can_load_text,
            style: const TextStyle(color: Colors.black),
          )
        ]);
        break;
      case LoadStatus.loading:
        return buildRow([
          const SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            S.of(context).loading_text,
            style: const TextStyle(color: Colors.black),
          )
        ]);
        break;
      case LoadStatus.noMore:
        return buildRow([
          const Icon(Icons.vertical_align_bottom),
          const SizedBox(
            width: 10,
          ),
          Text(
            S.of(context).no_more_text,
            style: const TextStyle(color: Colors.black),
          )
        ]);
        break;
      case LoadStatus.failed:
        return buildRow([
          const Icon(Icons.sms_failed),
          const SizedBox(
            width: 10,
          ),
          Text(
            S.of(context).load_fail,
            style: const TextStyle(color: Colors.black),
          )
        ]);
        break;
    }
    return null;
  }

  Widget buildWaterFlow() {
    final barHeight = MediaQueryData.fromWindow(window).padding.top;
    return FloatingSearchBarScrollNotifier(
      child: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        // onRefresh: () async {
        //   await Future.delayed(const Duration(seconds: 3), () {
        //     _refreshController.refreshCompleted();
        //   });
        // },
        // onLoading: () async {
        //   await Future.delayed(const Duration(seconds: 3), () {
        //     _refreshController.loadComplete();
        //   });
        // },
        footer: CustomFooter(
          builder: _buildFooter,
        ),
        controller: _refreshController,
        header: MaterialClassicHeader(
          distance: barHeight + 70,
          height: barHeight + 80,
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoadMore,
        child: WaterfallFlow.builder(
          padding: EdgeInsets.only(top: 60 + barHeight),
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
