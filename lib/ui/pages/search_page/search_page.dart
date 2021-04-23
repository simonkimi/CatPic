import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:catpic/ui/fragment/empty_website/empty_website.dart';
import 'package:catpic/ui/fragment/post_result/post_result.dart';
import 'package:catpic/main.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:flutter/material.dart';

enum SearchType { POST, POOL, ARTIST }

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String searchText;
  late SearchType searchType;
  late Widget searchBody;
  late StreamSubscription<EventSiteChange> _eventSiteChangeListener;
  DateTime lastClickBack = DateTime.now();

  @override
  void initState() {
    super.initState();
    searchText = '';
    searchType = SearchType.POST;
    searchBody = buildSearchBody(searchText, searchType);

    _eventSiteChangeListener =
        EventBusUtil().bus.on<EventSiteChange>().listen((event) {
      changeSearchBody(searchText, searchType);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventSiteChangeListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        drawer: MainDrawer(),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1),
          child: searchBody,
        ),
      ),
      onWillPop: () {
        final nowTime = DateTime.now();
        if (nowTime.difference(lastClickBack) > const Duration(seconds: 1)) {
          BotToast.showText(text: I18n.g.click_again_to_exit);
          lastClickBack = nowTime;
          return Future.value(false);
        }
        return Future.value(true);
      },
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
            adapter: getAdapter(mainStore.websiteEntity!),
          );
        case SearchType.POOL:
          throw Exception('TODO POOL');
        case SearchType.ARTIST:
          throw Exception('TODO ARTIST');
      }
    }
    return EmptyWebsiteFragment();
  }
}
