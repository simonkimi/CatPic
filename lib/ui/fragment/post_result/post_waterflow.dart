import 'dart:ui' as ui;
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/fragment/post_result/store/post_result_store.dart';
import 'package:catpic/ui/pages/post_image_view/post_image_view.dart';
import 'package:catpic/utils/cached_dio_image_provider.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:catpic/main.dart';
import 'package:catpic/i18n.dart';

class PostWaterFlow extends StatelessWidget {
  const PostWaterFlow({Key? key, required this.store, required this.dio})
      : super(key: key);

  final PostResultStore store;
  final Dio dio;

  @override
  Widget build(BuildContext context) {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return Observer(builder: (_) {
      return FloatingSearchBarScrollNotifier(
        child: SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          footer: CustomFooter(
            builder: _buildFooter,
          ),
          controller: store.refreshController,
          header: MaterialClassicHeader(
            distance: barHeight + 70,
            height: barHeight + 80,
          ),
          onRefresh: store.onRefresh,
          onLoading: store.onLoadMore,
          child: WaterfallFlow.builder(
            padding: EdgeInsets.only(top: 60 + barHeight, left: 10, right: 10),
            gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: settingStore.previewRowNum,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemCount: store.postList.length,
            itemBuilder: _itemBuilder,
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
          builder: (context) => PostImageViewPage(
            favicon: mainStore.websiteEntity?.favicon,
            dio: getAdapter(mainStore.websiteEntity!).dio,
            postList: store.postList,
            index: index,
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
      key: ValueKey('item${post.id}${post.md5}'),
      title: '# ${post.id}',
      subTitle: '${post.width} x ${post.height}',
      body: ExtendedImage(
        image: CachedDioImageProvider(
          dio: dio,
          url: imageUrl,
          cachedKey: imageUrl,
          cachedImg: true,
        ),
        handleLoadingProgress: true,
        enableLoadState: true,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              var progress = state.loadingProgress?.expectedTotalBytes != null
                  ? state.loadingProgress!.cumulativeBytesLoaded /
                      state.loadingProgress!.expectedTotalBytes!
                  : 0.0;
              progress = progress.isFinite ? progress : 0;
              return InkWell(
                onTap: loadDetail,
                child: AspectRatio(
                  aspectRatio: post.width / post.height,
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                ),
              );
            case LoadState.completed:
              return InkWell(
                onTap: loadDetail,
                child: Hero(
                  tag: '${post.id}|${post.md5}',
                  child: AspectRatio(
                    aspectRatio: post.width / post.height,
                    child: state.completedWidget,
                  ),
                ),
              );
            case LoadState.failed:
              return InkWell(
                onTap: () {
                  state.reLoadImage();
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
                      Text(I18n.g.tap_to_reload),
                    ],
                  ),
                ),
              );
          }
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
}
