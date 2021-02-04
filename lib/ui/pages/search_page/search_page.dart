import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'dart:ui';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _searchBarController = FloatingSearchBarController();
  var _refreshController = RefreshController(initialRefresh: false);

  var itemCount = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: buildSearchBar(),
    );
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
            itemCount += 15;
          });
          _refreshController.loadComplete();
        },
        child: WaterfallFlow.builder(
          padding: EdgeInsets.only(top: 60 + height),
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
          itemCount: itemCount,
          itemBuilder: (ctx, index) {
            return PostPreviewCard(
              key: Key('item$index'),
              title: '# $index',
              subTitle: 'Test',
            );
          },
        ),
      ),
    );
  }
}
