import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:catpic/ui/fragment/empty_website/empty_website_fragment.dart';
import 'package:catpic/ui/fragment/post_result/post_result_fragment.dart';
import 'package:catpic/data/store/main/main_store.dart';
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


  @override
  void initState() {
    super.initState();
    searchText = '';
    searchType = SearchType.POST;
    searchBody = buildSearchBody(searchText, searchType);
  }

  @override
  void dispose() {
    super.dispose();
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
