import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/fab.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/fragment/tag_search_bar/tag_search_bar.dart';
import 'package:catpic/ui/pages/booru_page/result/post_result/post_waterflow.dart';
import 'package:catpic/ui/pages/booru_page/result/post_result/store/post_result_store.dart';
import 'package:flutter/material.dart';

class PostResultFragment extends StatelessWidget {
  PostResultFragment({
    Key? key,
    this.searchText = '',
    required this.adapter,
    required this.isFavourite,
  })  : store = PostResultStore(
          adapter: adapter,
          searchText: searchText,
          isFavourite: isFavourite,
        ),
        super(key: key);

  final String searchText;
  final BooruAdapter adapter;
  final PostResultStore store;
  final bool isFavourite;
  final tmpController = SearchBarTmpController();

  @override
  Widget build(BuildContext context) {
    return TagSearchBar(
      defaultHint: searchText,
      searchText: searchText,
      tmpController: tmpController,
      onSearch: (value) {
        print('onSearch $value');
        store.onNewSearch(value.trim());
      },
      body: Scaffold(
        body: PostWaterFlow(
          store: store,
          dio: adapter.dio,
          onAddTag: (value) {
            tmpController.tmp = tmpController.tmp.trim() + ' $value ';
          },
        ),
        floatingActionButton: FloatActionBubble(loadMoreStore: store),
      ),
    );
  }
}
