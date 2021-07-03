import 'dart:ui' as ui;
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/themes.dart';
import 'package:catpic/ui/components/dark_image.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/components/pull_to_refresh_footer.dart';
import 'package:catpic/ui/pages/booru_page/post_image_view/post_image_view.dart';
import 'package:catpic/ui/pages/booru_page/result/loading/loading.dart';
import 'package:catpic/ui/pages/booru_page/result/post_result/store/post_result_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:catpic/main.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/data/store/setting/setting_store.dart';

class PostWaterFlow extends StatelessWidget {
  PostWaterFlow({
    Key? key,
    required this.store,
    required this.dio,
    required this.onAddTag,
  }) : super(key: key);
  final PostResultStore store;
  final ValueChanged<String> onAddTag;
  final Dio dio;

  final retryList = <Function>[];

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: () {
          if (store.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (store.observableList.isEmpty) return EmptyWidget(store: store);
          return buildList();
        }(),
      );
    });
  }

  Widget buildList() {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return Scrollbar(
      showTrackOnHover: true,
      child: FloatingSearchBarScrollNotifier(
        child: SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          footer: CustomFooter(
            builder: buildFooter,
          ),
          controller: store.refreshController,
          header: MaterialClassicHeader(
            distance: barHeight + 70,
            height: barHeight + 80,
          ),
          onRefresh: store.onRefresh,
          onLoading: store.onLoadMore,
          child: WaterfallFlow.builder(
            controller: store.listScrollController,
            padding: EdgeInsets.only(top: 60 + barHeight, left: 10, right: 10),
            gridDelegate: SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              maxCrossAxisExtent: CardSize.of(settingStore.cardSize).toDouble(),
            ),
            itemCount: store.postList.length,
            itemBuilder: _itemBuilder,
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index >= store.postList.length) return const SizedBox();
    final post = store.postList[index];
    final loadDetail = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostImageViewPage.count(
            favicon: mainStore.websiteEntity?.favicon,
            adapter: BooruAdapter.fromWebsite(mainStore.websiteEntity!),
            postList: store.postList,
            onAddTag: onAddTag,
            index: index,
          ),
        ),
      );
    };

    return PostPreviewCard(
      key: ValueKey('item${post.id}${post.md5}'),
      title: '# ${post.id}',
      subTitle: '${post.width} x ${post.height}',
      body: DioImage(
        imageUrl: post.getPreviewImg(),
        dio: dio,
        imageBuilder: (context, imgData) {
          return InkWell(
            key: ValueKey('loaded${post.id}'),
            onTap: loadDetail,
            child: AspectRatio(
              aspectRatio: post.width / post.height,
              child: DarkImage(image: MemoryImage(imgData, scale: 0.1)),
            ),
          );
        },
        loadingBuilder: (context, progress) {
          return InkWell(
            key: ValueKey('loading${post.id}'),
            onTap: loadDetail,
            child: AspectRatio(
              aspectRatio: post.width / post.height,
              child: Container(
                color: isDarkMode(context)
                    ? darkColors[index % darkColors.length]
                    : Colors.primaries[index % Colors.primaries.length][50],
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      value: (progress.expectedTotalBytes == null ||
                              progress.expectedTotalBytes == 0)
                          ? 0
                          : progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, reload) {
          retryList.add(reload);
          return InkWell(
            key: ValueKey('error${post.id}'),
            onTap: () {
              for (final retry in retryList) retry();
              retryList.clear();
            },
            child: AspectRatio(
              aspectRatio: post.width / post.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.error),
                  const SizedBox(height: 10),
                  Text(I18n.of(context).tap_to_reload),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
