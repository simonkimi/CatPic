import 'dart:async';

import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/network/api/ehentai/eh_filter.dart';
import 'package:catpic/ui/fragment/main_drawer/main_drawer.dart';
import 'package:catpic/ui/pages/eh_page/index_page/index_result.dart';
import 'package:catpic/ui/pages/booru_page/result/empty_website/empty_website.dart';
import 'package:catpic/ui/pages/eh_page/popular_page/popular_page.dart';
import 'package:catpic/ui/pages/eh_page/watched_page/watched_page.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:flutter/material.dart';

import 'package:catpic/main.dart';

enum EHSearchType {
  INDEX,
  WATCHED,
  POPULAR,
}

class EhPage extends StatefulWidget {
  const EhPage({
    Key? key,
    this.searchText = '',
    this.searchType = EHSearchType.INDEX,
    this.baseFilter,
  }) : super(key: key);

  final String searchText;
  final EHSearchType searchType;
  final EhAdvanceFilter? baseFilter;

  @override
  _EhPageState createState() => _EhPageState();
}

class _EhPageState extends State<EhPage> {
  late final String searchText = widget.searchText;
  late final EHSearchType searchType = widget.searchType;
  late Widget searchBody = buildSearchBody(searchText, searchType);
  late final StreamSubscription<EventSiteChange> _eventSiteChangeListener;

  @override
  void initState() {
    super.initState();
    mainStore.addSearchPage();
    _eventSiteChangeListener =
        EventBusUtil().bus.on<EventSiteChange>().listen((event) {
      print('Event bus EventSiteChange');
      changeSearchBody(searchText, searchType);
    });
    print('EhPageCount: ${mainStore.searchPageCount}');
  }

  @override
  void dispose() {
    super.dispose();
    mainStore.descSearchPage();
    print('EhPageCount: ${mainStore.searchPageCount}');
    _eventSiteChangeListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        ehSearchType: searchType,
        onEHSearchChange: (newType) => newType != searchType,
      ),
      body: searchBody,
    );
  }

  void changeSearchBody(String tag, EHSearchType type) {
    if (tag == searchText && type == searchType) {
      return;
    }
    final widget = buildSearchBody(tag, type);
    setState(() {
      searchBody = widget;
    });
  }

  Widget buildSearchBody(String tag, EHSearchType type) {
    if (mainStore.websiteEntity != null) {
      final key = UniqueKey();
      final adapter = EHAdapter(mainStore.websiteEntity!);
      switch (type) {
        case EHSearchType.INDEX:
          return EhIndexResult(
            key: key,
            searchText: tag,
            adapter: adapter,
            baseFilter: widget.baseFilter,
          );
        case EHSearchType.WATCHED:
          return EhWatchedResult(
            key: key,
            searchText: tag,
            adapter: adapter,
          );
        case EHSearchType.POPULAR:
          return EhPopularResult(
            key: key,
            adapter: adapter,
          );
      }
    }
    return EmptyWebsiteFragment();
  }
}
