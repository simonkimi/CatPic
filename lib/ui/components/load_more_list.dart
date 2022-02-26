import 'dart:ui' as ui;
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/ui/components/pull_to_refresh_footer.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LoadMoreList extends StatelessWidget {
  const LoadMoreList({
    Key? key,
    required this.store,
    required this.body,
    this.enablePullDown = true,
    this.enablePullUp = true,
  }) : super(key: key);

  final ILoadMore store;
  final Widget body;
  final bool enablePullUp;
  final bool enablePullDown;

  @override
  Widget build(BuildContext context) {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return Scrollbar(
      showTrackOnHover: true,
      child: FloatingSearchBarScrollNotifier(
        child: SmartRefresher(
          enablePullUp: enablePullUp,
          enablePullDown: enablePullDown,
          footer: const CustomFooter(
            builder: buildFooter,
          ),
          controller: store.refreshController,
          header: MaterialClassicHeader(
            distance: barHeight + 70,
            height: barHeight + 80,
          ),
          onRefresh: enablePullDown ? store.onRefresh : null,
          onLoading: enablePullUp ? store.onLoadMore : null,
          child: body,
        ),
      ),
    );
  }
}
