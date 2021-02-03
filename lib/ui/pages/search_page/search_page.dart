import 'dart:math';

import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _searchBarController = FloatingSearchBarController();
  var _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            buildWaterFlow(),
            buildSearchBar(),
          ],
        ),
      ),
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
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: true,
      controller: _refreshController,
      header: MaterialClassicHeader(
        distance: 70,
      ),
      onLoading: () {},
      child: WaterfallFlow.builder(
        padding: EdgeInsets.only(top: 60),
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
        itemCount: Colors.accents.length,
        itemBuilder: (ctx, index) {
          return Container(
            color: Colors.accents[index],
            height: 100 + Random().nextInt(200).toDouble(),
          );
        },
      ),
    );
  }
}
