import 'dart:async';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/ui/fragment/main_drawer/main_drawer.dart';
import 'package:catpic/ui/pages/booru_page/result/artist_result/artist_result.dart';
import 'package:catpic/ui/pages/booru_page/result/popular_result/popular_result.dart';
import 'package:catpic/ui/pages/booru_page/result/tag_result/tag_result.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:flutter/material.dart';

import 'package:catpic/main.dart';
import 'empty_website/empty_website.dart';
import 'pool_result/pool_result.dart';
import 'post_result/post_result.dart';

enum SearchType {
  POST,
  POOL,
  ARTIST,
  TAGS,
  FAVOURITE,
  POPULAR,
}

class BooruPage extends StatefulWidget {
  const BooruPage({
    Key? key,
    this.searchText = '',
    this.searchType = SearchType.POST,
  }) : super(key: key);
  final String searchText;
  final SearchType searchType;

  @override
  _BooruPageState createState() => _BooruPageState();
}

class _BooruPageState extends State<BooruPage> {
  late final searchText = widget.searchText;
  late final searchType = widget.searchType;
  late var searchBody = buildSearchBody(searchText, searchType);
  late final StreamSubscription<EventSiteChange> _eventSiteChangeListener;

  late ILoadMore currentStore;

  @override
  void initState() {
    super.initState();
    mainStore.addSearchPage();
    _eventSiteChangeListener =
        EventBusUtil().bus.on<EventSiteChange>().listen((event) {
      print('Event bus EventSiteChange');
      changeSearchBody(searchText, searchType);
    });
    print('SearchPageCount: ${mainStore.searchPageCount}');
  }

  @override
  void dispose() {
    super.dispose();
    mainStore.descSearchPage();
    print('SearchPageCount: ${mainStore.searchPageCount}');
    _eventSiteChangeListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        boooruType: searchType,
        onSearchChange: (newType) => newType != searchType,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1),
        child: searchBody,
      ),
    );
  }

  void changeSearchBody(String tag, SearchType type) {
    if (tag == searchText && type == searchType) {
      return;
    }
    final widget = buildSearchBody(tag, type);
    setState(() {
      searchBody = widget;
    });
  }

  Widget buildSearchBody(String tag, SearchType type) {
    if (mainStore.websiteEntity != null) {
      final key = UniqueKey();
      final adapter = BooruAdapter.fromWebsite(mainStore.websiteEntity!);
      switch (searchType) {
        case SearchType.FAVOURITE:
        case SearchType.POST:
          return PostResultFragment(
            key: key,
            searchText: tag,
            adapter: adapter,
            isFavourite: searchType == SearchType.FAVOURITE,
          );
        case SearchType.POOL:
          return PoolResultFragment(
            key: key,
            adapter: adapter,
            searchText: tag,
          );
        case SearchType.ARTIST:
          return ArtistResultFragment(
            key: key,
            adapter: adapter,
            tag: tag,
          );
        case SearchType.TAGS:
          return TagResultFragment(
            key: key,
            adapter: adapter,
            searchText: tag,
          );
        case SearchType.POPULAR:
          return PopularResultFragment(
            adapter: adapter,
            key: key,
          );
      }
    }
    return EmptyWebsiteFragment();
  }
}
