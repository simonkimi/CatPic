import 'dart:ui' as ui;
import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/ui/components/cached_image.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/fragment/tag_search_bar/tag_search_bar.dart';
import 'package:catpic/ui/pages/image_view_page/image_view_page.dart';
import 'package:catpic/main.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'post_result_store.dart';

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

class _PostResultFragmentState extends State<PostResultFragment> {
  late final PostResultStore _store =
      PostResultStore(searchText: widget.searchText, adapter: widget.adapter);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => _buildSearchBar(),
    );
  }

  Widget _buildSearchBar() {
    return TagSearchBar(
      defaultHint: widget.searchText,
      onSearch: (value) {
        _store.launchNewSearch(value.trim());
      },
      body: _buildWaterFlow(),
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
          return InkWell(
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
          return InkWell(
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
                  Text(I18n.of(context).tap_to_reload),
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
            I18n.of(context).idle_loading,
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
            I18n.of(context).can_load_text,
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
            I18n.of(context).loading_text,
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
            I18n.of(context).no_more_text,
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
            I18n.of(context).load_fail,
            style: const TextStyle(color: Colors.black),
          )
        ]);
    }
  }

  Widget _buildWaterFlow() {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return FloatingSearchBarScrollNotifier(
      child: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        footer: CustomFooter(
          builder: _buildFooter,
        ),
        controller: _store.refreshController,
        header: MaterialClassicHeader(
          distance: barHeight + 70,
          height: barHeight + 80,
        ),
        onRefresh: _store.onRefresh,
        onLoading: _store.onLoadMore,
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
