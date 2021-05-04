import 'dart:async';

import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/default_button.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../../i18n.dart';
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
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        // backgroundColor: Theme.of(context).primaryColor,
        // foregroundColor: Colors.white,
        overlayColor: Colors.transparent,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.refresh),
            onTap: () async {
              await currentStore.onRefresh();
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.last_page),
            onTap: () async {
              final page = await showDialog(
                  context: context,
                  builder: (context) {
                    final inputController = TextEditingController();
                    return AlertDialog(
                      title: Text(I18n.of(context).jump_page),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            TextField(
                              controller: inputController,
                              decoration: InputDecoration(
                                hintText: I18n.of(context).input_page,
                                labelText: I18n.of(context).page,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                            )
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(-1);
                          },
                          child: Text(I18n.of(context).negative),
                        ),
                        DefaultButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(int.tryParse(inputController.text) ?? 1);
                          },
                          child: Text(I18n.of(context).positive),
                        )
                      ],
                    );
                  });
              currentStore.onJumpPage(page);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.keyboard_arrow_up),
            onTap: () async {
              currentStore.listScrollController.animateTo(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
          ),
        ],
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
