import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/fragment/tag_search_bar/tag_search_bar.dart';
import 'package:catpic/ui/pages/search_page/fragment/post_result/post_waterflow.dart';
import 'package:catpic/ui/pages/search_page/fragment/post_result/store/post_result_store.dart';
import 'package:flutter/material.dart';

class PostResultFragment extends StatelessWidget {
  PostResultFragment({
    Key? key,
    this.searchText = '',
    required this.adapter,
  })   : _store = PostResultStore(
          searchText: searchText,
          adapter: adapter,
        ),
        super(key: key);
  final String searchText;
  final BooruAdapter adapter;
  final PostResultStore _store;
  final tmpController = SearchBarTmpController();

  @override
  Widget build(BuildContext context) {
    return TagSearchBar(
      defaultHint: searchText,
      searchText: searchText,
      tmpController: tmpController,
      onSearch: (value) {
        print('onSearch $value');
        _store.onNewSearch(value.trim());
      },
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
        child: PostWaterFlow(
          store: _store,
          dio: adapter.dio,
          onAddTag: (value) {
            tmpController.tmp = tmpController.tmp.trim() + ' $value ';
          },
        ),
      ),
    );
  }
}