import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:catpic/ui/fragment/post_result/post_result_fragment.dart';
import 'package:catpic/ui/store/main/main_store.dart';
import 'package:flutter/material.dart';

enum SearchType { POST, POOL, ARTIST }

class SearchPage extends StatefulWidget {
  final String searchText;
  final SearchType searchType;

  const SearchPage({
    Key key,
    this.searchText = '',
    this.searchType = SearchType.POST,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: buildSearchBody(),
    );
  }

  Widget buildSearchBody() {
    if (mainStore.websiteEntity != null) {
      switch (widget.searchType) {
        case SearchType.POOL:
          throw Exception("TODO");
        case SearchType.ARTIST:
          throw Exception("TODO");
        case SearchType.POST:
        default:
          return PostResultFragment(
            searchText: widget.searchText,
            adapter: mainStore.websiteEntity.getAdapter(),
          );
      }
    }
    return null;
  }
}
