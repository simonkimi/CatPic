import 'dart:ui' as ui;
import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/exception/no_more_page.dart';
import 'package:catpic/generated/l10n.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/ui/components/cached_image.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/pages/image_view_page/image_view_page.dart';
import 'package:catpic/data/store/main/main_store.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'post_result_store.dart';

typedef ValueCallBack = void Function(String);

class PostResultFragment extends StatefulWidget {
  const PostResultFragment({
    Key? key,
    this.searchText = '',
    required this.adapter,
  }) : super(key: key);

  final String searchText;
  final BooruAdapter adapter;

  @override
  _PostResultFragmentState createState() => _PostResultFragmentState();
}

mixin _PostResultFragmentMixin<T extends StatefulWidget> on State<T> {
  final _searchBarController = FloatingSearchBarController();
  final _refreshController = RefreshController(initialRefresh: false);
  late List<SearchSuggestions> suggestionList;

  late PostResultStore _store;

  Future<void> _onRefresh() async {
    print('_onRefresh');
    try {
      await _store.refresh();
      _refreshController.loadComplete();
      _refreshController.refreshCompleted();
    } on NoMorePage {
      _refreshController.loadNoData();
      _refreshController.refreshCompleted();
    } on DioError catch (e) {
      _refreshController.loadFailed();
      _refreshController.refreshFailed();
      BotToast.showText(text: '${S.of(context).network_error}:${e.message}');
    } catch (e) {
      debugPrint(e.toString());
      _refreshController.loadFailed();
      _refreshController.refreshFailed();
      BotToast.showText(text: e.toString());
    }
  }

  Future<void> _onLoadMore() async {
    debugPrint('_onLoadMore');
    if (_refreshController.isRefresh) {
      _refreshController.loadComplete();
      return;
    }
    try {
      await _store.loadNextPage();
      _refreshController.loadComplete();
    } on NoMorePage {
      _refreshController.loadNoData();
    } on DioError catch (e) {
      _refreshController.loadFailed();
      BotToast.showText(text: '${S.of(context).network_error}:${e.message}');
    } catch (e) {
      print(e.toString());
      _refreshController.loadFailed();
      BotToast.showText(text: e.toString());
    }
  }

  Future<void> _newSearch(String tag) async {
    await _store.launchNewSearch(tag);
    await _refreshController.requestRefresh();
  }

  Future<void> _searchTag(String tag) async {
    if (tag.isNotEmpty) {
      // 推荐Tag
      final lastTag = tag.split(' ').last;
      final dao = DatabaseHelper().tagDao;
      final list = await dao.getStart(mainStore.websiteEntity!.id, lastTag);
      setState(() {
        suggestionList = list.map((e) => SearchSuggestions(e.tag)).toList();
      });
    } else {
      // 历史搜索
      final dao = DatabaseHelper().historyDao;
      final list = await dao.getAll();
      setState(() {
        suggestionList = list
            .where((e) => e.history.trim().isNotEmpty)
            .map((e) => SearchSuggestions(e.history))
            .toList();
      });
    }
  }

  Future<void> _setSearchHistory(String tag) async {
    if (tag.isEmpty) return;
    final dao = DatabaseHelper().historyDao;
    final history = await dao.get(tag);
    if (history != null) {
      await dao.updateHistory(history.copyWith(
        createTime: DateTime.now()
      ));
    } else {
      dao.insert(HistoryTableCompanion.insert(history: tag));
    }
  }
}

class _PostResultFragmentState extends State<PostResultFragment>
    with _PostResultFragmentMixin {
  @override
  void initState() {
    super.initState();
    suggestionList = [];
    _store =
        PostResultStore(searchText: widget.searchText, adapter: widget.adapter);
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
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
      onSubmitted: (value) async {
        _newSearch(value.trim());
        _setSearchHistory(value.trim());
      },
      onFocusChanged: (isFocus) {
        _searchTag(_searchBarController.query);
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
      onQueryChanged: _searchTag,
      candidateBuilder: _buildSuggestionList,
    );
  }

  Widget _buildSuggestionList(
      BuildContext context, Animation<double> transition) {
    return Material(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: suggestionList.map((e) {
          return ListTile(
            title: Text(e.title),
            onTap: () {
              final newTag = _searchBarController.query.split(' ')
                ..removeLast()
                ..add(e.title);
              _searchBarController.query = newTag.join(' ') + ' ';
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _itemBuilder(BuildContext ctx, int index) {
    final post = _store.postList[index];

    final loadDetail = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewPage(
            dio: getAdapter(mainStore.websiteEntity!).dio,
            booruPost: post,
            heroTag: '${post.id}|${post.md5}',
          ),
        ),
      );
    };

    late String imageUrl;
    switch (settingStore.previewQuality) {
      case ImageQuality.preview:
        imageUrl = post.previewURL;
        break;
      case ImageQuality.sample:
        imageUrl = post.sampleURL;
        break;
      case ImageQuality.raw:
        imageUrl = post.imgURL;
        break;
    }

    return PostPreviewCard(
      key: Key('item${post.id}${post.md5}'),
      title: '# ${post.id}',
      subTitle: '${post.width} x ${post.height}',
      body: CachedDioImage(
        dio: widget.adapter.dio,
        imgUrl: imageUrl,
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
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: ((progress.expectedTotalBytes ?? 0) != 0) &&
                            ((progress.cumulativeBytesLoaded) != 0)
                        ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                        : 0.0,
                    strokeWidth: 2.5,
                  ),
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
                children: [
                  const Icon(Icons.error),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(S.of(context).tap_to_reload),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context, LoadStatus? status) {
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

    switch (status ?? LoadStatus.loading) {
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
    }
  }

  Widget buildWaterFlow() {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return FloatingSearchBarScrollNotifier(
      child: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
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
          padding: EdgeInsets.only(top: 60 + barHeight, left: 10, right: 10),
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: settingStore.previewRowNum,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: _store.postList.length,
          itemBuilder: _itemBuilder,
        ),
      ),
    );
  }
}
