import 'dart:async';

import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:catpic/ui/fragment/empty_website/empty_website.dart';
import 'package:catpic/ui/fragment/pool_result/pool_result.dart';
import 'package:catpic/ui/fragment/post_result/post_result.dart';
import 'package:catpic/main.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:flutter/material.dart';

enum SearchType {
  POST,
  POOL,
  ARTIST,
  TAGS,
  POOL_POST,
}

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    this.searchText = '',
    this.searchType = SearchType.POST,
  }) : super(key: key);
  final String searchText;
  final SearchType searchType;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final searchText = widget.searchText;
  late final searchType = widget.searchType;
  late var searchBody = buildSearchBody(searchText, searchType);
  late final StreamSubscription<EventSiteChange> _eventSiteChangeListener;

  @override
  void initState() {
    super.initState();
    mainStore.searchPageCount += 1;
    _eventSiteChangeListener =
        EventBusUtil().bus.on<EventSiteChange>().listen((event) {
      changeSearchBody(searchText, searchType);
    });
    print('SearchPageCount: ${mainStore.searchPageCount}');
  }

  @override
  void dispose() {
    super.dispose();
    mainStore.searchPageCount -= 1;
    print('SearchPageCount: ${mainStore.searchPageCount}');
    _eventSiteChangeListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        type: searchType,
        onSearchChange: (newType) => newType != searchType,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1),
        child: searchBody,
      ),
    );
  }

  void changeSearchBody(String tag, SearchType type) {
    final widget = buildSearchBody(tag, type);
    setState(() {
      searchBody = widget;
    });
  }

  Widget buildSearchBody(String tag, SearchType type) {
    if (mainStore.websiteEntity != null) {
      switch (searchType) {
        case SearchType.POST:
          return PostResultFragment(
            key: ValueKey('${mainStore.websiteEntity!.host}${type.index}$tag'),
            searchText: tag,
            adapter: BooruAdapter.fromWebsite(mainStore.websiteEntity!),
          );
        case SearchType.POOL:
          return PoolResultFragment(
            key: ValueKey('${mainStore.websiteEntity!.host}${type.index}$tag'),
            searchText: tag,
            adapter: BooruAdapter.fromWebsite(mainStore.websiteEntity!),
          );
        case SearchType.POOL_POST:
          return PostResultFragment(
            key: ValueKey('${mainStore.websiteEntity!.host}${type.index}$tag'),
            searchText: tag,
            adapter: BooruAdapter.fromWebsite(mainStore.websiteEntity!),
          );
        case SearchType.ARTIST:
          throw Exception('TODO ARTIST');
      }
    }
    return EmptyWebsiteFragment();
  }
}
