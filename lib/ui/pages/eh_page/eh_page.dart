import 'dart:async';

import 'package:catpic/ui/fragment/main_drawer/main_drawer.dart';
import 'package:catpic/ui/pages/search_page/booru/empty_website/empty_website.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

enum EHSearchType {
  INDEX,
}

class EhPage extends StatefulWidget {
  const EhPage({
    Key? key,
    this.searchText = '',
    this.searchType = EHSearchType.INDEX,
  }) : super(key: key);

  final String searchText;
  final EHSearchType searchType;

  @override
  _EhPageState createState() => _EhPageState();
}

class _EhPageState extends State<EhPage> {
  late final searchText = widget.searchText;
  late final searchType = widget.searchType;
  late var searchBody = buildSearchBody(searchText, searchType);
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
        ehSearchType: searchType,
        onEHSearchChange: (newType) => newType != searchType,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1),
        child: searchBody,
      ),
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
    }
    return EmptyWebsiteFragment();
  }
}
