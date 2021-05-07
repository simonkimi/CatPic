import 'dart:async';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/ui/fragment/main_drawer/main_drawer.dart';
import 'package:catpic/ui/pages/search_page/fragment/artist_result/artist_result.dart';
import 'package:catpic/ui/pages/search_page/fragment/artist_result/store/artist_result_store.dart';
import 'package:catpic/ui/pages/search_page/fragment/pool_result/store/pool_result_store.dart';
import 'package:catpic/ui/pages/search_page/fragment/post_result/store/post_result_store.dart';
import 'package:catpic/ui/pages/search_page/fragment/tag_result/store/tag_result_store.dart';
import 'package:catpic/ui/pages/search_page/fragment/tag_result/tag_result.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:flutter/material.dart';

import 'package:catpic/main.dart';
import 'fragment/empty_website/empty_website.dart';
import 'fragment/pool_result/pool_result.dart';
import 'fragment/post_result/post_result.dart';

enum SearchType {
  POST,
  POOL,
  ARTIST,
  TAGS,
  FAVOURITE,
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
          currentStore = PostResultStore(
            adapter: adapter,
            searchText: tag,
            isFavourite: searchType == SearchType.FAVOURITE,
          );
          return PostResultFragment(
            key: key,
            searchText: tag,
            adapter: adapter,
            store: currentStore as PostResultStore,
          );
        case SearchType.POOL:
          currentStore = PoolResultStore(
            adapter: adapter,
            searchText: tag,
          );
          return PoolResultFragment(
            key: key,
            adapter: adapter,
            store: currentStore as PoolResultStore,
          );
        case SearchType.ARTIST:
          currentStore = ArtistResultStore(
            adapter: adapter,
            searchText: tag,
          );
          return ArtistResultFragment(
            key: key,
            adapter: adapter,
            store: currentStore as ArtistResultStore,
          );
        case SearchType.TAGS:
          currentStore = TagResultStore(
            adapter: adapter,
            searchText: tag,
          );
          return TagResultFragment(
            key: key,
            adapter: adapter,
            store: currentStore as TagResultStore,
          );
      }
    }
    return EmptyWebsiteFragment();
  }
}
