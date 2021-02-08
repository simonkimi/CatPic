import 'dart:async';

import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:catpic/ui/fragment/empty_website/empty_website_fragment.dart';
import 'package:catpic/ui/fragment/post_result/post_result_fragment.dart';
import 'package:catpic/ui/store/main/main_store.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:flutter/material.dart';
import 'package:catpic/router.dart';

enum SearchType { POST, POOL, ARTIST }

class SearchPage extends StatefulWidget {
  static String routeName = 'SearchPage';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText;
  SearchType searchType;
  Widget searchBody;

  StreamSubscription<EventSiteChange> _eventSiteChangeListener;

  @override
  void initState() {
    super.initState();
    searchText = '';
    searchType = SearchType.POST;
    searchBody = buildSearchBody(searchText, searchType);

    _eventSiteChangeListener =
        EventBusUtil().bus.on<EventSiteChange>().listen((event) {
      MyRouteDelegate.of(context).cleanSearchPageRouter();
      setState(() {
        searchBody = buildSearchBody('', SearchType.POST);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventSiteChangeListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: searchBody,
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
            searchText: tag,
            adapter: mainStore.websiteEntity.getAdapter(),
            onSearch: (value) {
              changeSearchBody(value.trim(), SearchType.POST);
            },
          );
        case SearchType.POOL:
          throw Exception('TODO POOL');
          break;
        case SearchType.ARTIST:
          throw Exception('TODO ARTIST');
          break;
      }
    }
    return EmptyWebsiteFragment();
  }
}
