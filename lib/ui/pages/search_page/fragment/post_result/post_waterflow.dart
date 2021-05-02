import 'dart:ui' as ui;
import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/components/pull_to_refresh_footer.dart';
import 'package:catpic/ui/pages/post_image_view/post_image_view.dart';
import 'package:catpic/ui/pages/search_page/fragment/post_result/store/post_result_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:catpic/main.dart';
import 'package:catpic/i18n.dart';

class PostWaterFlow extends StatelessWidget {
  const PostWaterFlow({
    Key? key,
    required this.store,
    required this.dio,
    required this.onAddTag,
  }) : super(key: key);

  final PostResultStore store;
  final ValueChanged<String> onAddTag;
  final Dio dio;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (store.lock.locked) {
        store.refreshController.requestRefresh();
      }
    });

    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return Observer(builder: (_) {
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
              padding:
                  EdgeInsets.only(top: 60 + barHeight, left: 10, right: 10),
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: settingStore.previewRowNum,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: store.postList.length,
              itemBuilder: _itemBuilder,
            ),
          ),
        ),
      );
    });
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final post = store.postList[index];

    final loadDetail = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostImageViewPage.count(
            favicon: mainStore.websiteEntity?.favicon,
            dio: BooruAdapter.fromWebsite(mainStore.websiteEntity!).dio,
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
              child: Image(image: MemoryImage(imgData, scale: 0.1)),
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
                color: Colors.primaries[index % Colors.primaries.length][50],
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
          return InkWell(
            key: ValueKey('error${post.id}'),
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
}
