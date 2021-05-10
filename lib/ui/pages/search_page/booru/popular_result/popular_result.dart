import 'dart:ui' as ui;
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/dark_image.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/components/pull_to_refresh_footer.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/pages/post_image_view/post_image_view.dart';
import 'package:catpic/ui/pages/search_page/booru/components/fab/fab.dart';
import 'package:catpic/ui/pages/search_page/booru/loading/loading.dart';
import 'package:catpic/ui/pages/search_page/booru/popular_result/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../../../../i18n.dart';
import '../../../../../main.dart';
import '../../../../../themes.dart';

class PopularResultFragment extends StatelessWidget {
  PopularResultFragment({Key? key, required this.store}) : super(key: key);

  final PopularResultStore store;

  final retryList = <Function>[];

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      body: buildBody(),
      candidateBuilder: (BuildContext context, Animation<double> transition) {
        return const SizedBox();
      },
      actions: [
        FloatingSearchBarAction(
          showIfClosed: true,
          showIfOpened: true,
          child: IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              final newData = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1970),
                lastDate: DateTime.now(),
              );
              if (newData != null)
                await store.setDate(newData.year, newData.month, newData.day);
            },
          ),
        ),
        FloatingSearchBarAction(
          showIfClosed: true,
          showIfOpened: true,
          child: PopupMenuButton<PopularType>(
            icon: const Icon(Icons.list_alt),
            itemBuilder: (context) {
              return [
                PopupMenuItem<PopularType>(
                  value: PopularType.DAY,
                  child: Text(I18n.of(context).day),
                ),
                PopupMenuItem<PopularType>(
                  value: PopularType.WEEK,
                  child: Text(I18n.of(context).week),
                ),
                PopupMenuItem<PopularType>(
                  value: PopularType.MONTH,
                  child: Text(I18n.of(context).month),
                ),
              ];
            },
            onSelected: (value) async {
              if (store.popularType != value) await store.setType(value);
            },
          ),
        ),
      ],
    );
  }

  Scaffold buildBody() {
    return Scaffold(
      body: Observer(
        builder: (_) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: store.isLoading && store.observableList.isEmpty
                ? LoadingWidget(store: store)
                : buildList(),
          );
        },
      ),
      floatingActionButton: FloatActionBubble(loadMoreStore: store),
    );
  }

  Scrollbar buildList() {
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
            itemCount: store.observableList.length,
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
        dio: store.adapter.dio,
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
