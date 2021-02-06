import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'dart:ui';
import 'post_result_store.dart';

class PostResultFragment extends StatefulWidget {
  final String searchText;
  final BooruAdapter adapter;

  PostResultFragment({Key key, this.searchText, this.adapter}) : super(key: key);

  @override
  _PostResultFragmentState createState() => _PostResultFragmentState();
}

class _PostResultFragmentState extends State<PostResultFragment> {
  var _searchBarController = FloatingSearchBarController();
  var _refreshController = RefreshController(initialRefresh: false);

  PostResultStore store;

  @override
  Widget build(BuildContext context) {
    store = PostResultStore(
      searchText: widget.searchText,
      adapter: widget.adapter
    );

    return buildSearchBar();
  }

  Widget buildSearchBar() {
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

  Widget buildWaterFlow() {
    var height = MediaQueryData.fromWindow(window).padding.top;
    return FloatingSearchBarScrollNotifier(
      child: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        controller: _refreshController,
        header: MaterialClassicHeader(
          distance: 70,
        ),
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1500));
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          await Future.delayed(Duration(milliseconds: 1500));
          setState(() {
          });
          _refreshController.loadComplete();
        },
        child: WaterfallFlow.builder(
          padding: EdgeInsets.only(top: 60 + height),
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
          itemCount: store.postList.length,
          itemBuilder: (ctx, index) {
            var post = store.postList[index];
            return PostPreviewCard(
              key: Key('item${post.id}'),
              title: '# ${post.id}',
              subTitle: '${post.width} x ${post.height}',
            );
          },
        ),
      ),
    );
  }
}
