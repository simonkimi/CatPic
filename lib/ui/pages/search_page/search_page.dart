import 'package:catpic/generated/l10n.dart';
import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:catpic/ui/fragment/post_result/post_result_fragment.dart';
import 'package:catpic/ui/pages/website_manager/website_manager.dart';
import 'package:catpic/ui/store/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void initState() {
    super.initState();
    if (Get.arguments is Map) {
      searchText = Get.arguments['searchText'] ?? '';
      searchType = Get.arguments['searchType'] ?? SearchType.POST;
    } else {
      searchText = '';
      searchType = SearchType.POST;
    }
    searchBody = buildSearchBody(searchText, searchType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: searchBody,
    );
  }

  void changeSearchBody(String tag, SearchType type) {
    var widget = buildSearchBody(tag, type);
    setState(() {
      searchBody = widget;
    });
  }


  Widget buildSearchBody(String tag, SearchType type) {
    if (mainStore.websiteEntity != null) {
      switch(searchType) {
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
    return Container(
      child: FlatButton(
        child: Text(S.of(context).add_website),
        onPressed: () => Get.toNamed(WebsiteManagerPage.routeName),
      ),
    );
  }
}
