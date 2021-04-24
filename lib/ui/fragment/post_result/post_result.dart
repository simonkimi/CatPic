import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/tag_search_bar.dart';
import 'package:catpic/ui/fragment/post_result/post_filter.dart';
import 'package:catpic/ui/fragment/post_result/post_waterflow.dart';
import 'package:catpic/ui/fragment/post_result/store/filter_store.dart';
import 'package:catpic/ui/fragment/post_result/store/post_result_store.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class PostResultFragment extends StatefulWidget {
  const PostResultFragment({
    Key? key,
    this.searchText = '',
    required this.adapter,
  }) : super(key: key);

  final String searchText;
  final BooruAdapter adapter;

  @override
  _PostResultFragmentState createState() => _PostResultFragmentState();
}

class _PostResultFragmentState extends State<PostResultFragment> {
  late final PostResultStore _store = PostResultStore(
    searchText: widget.searchText,
    adapter: widget.adapter,
  );

  late final FloatingSearchBarController controller =
      FloatingSearchBarController();

  late final filterStore = FilterStore(controller.query);

  bool showFilter = false;
  var filterDisplaySwitch = false;

  @override
  Widget build(BuildContext context) {
    return TagSearchBar(
      defaultHint: widget.searchText,
      controller: controller,
      onSearch: (value) {
        print('onSearch $value');
        _store.launchNewSearch(value.trim());
      },
      onFilterDisplay: (value) {
        setState(() {
          filterDisplaySwitch = value;
        });
      },
      onTextChange: (value) {
        filterStore.setSearchText(value);
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
        child: filterDisplaySwitch
            ? PostFilter(
                controller: controller,
                store: filterStore,
              )
            : PostWaterFlow(
                store: _store,
                dio: widget.adapter.dio,
              ),
      ),
    );
  }
}
