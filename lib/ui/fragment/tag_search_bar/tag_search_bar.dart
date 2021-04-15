import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/store/main/main_store.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class TagSearchBar extends StatefulWidget {
  const TagSearchBar(
      {Key? key,
      this.searchText = 'CatPic',
      required this.onSearch,
      this.body,
      this.defaultHint})
      : super(key: key);

  final ValueChanged<String> onSearch;
  final String searchText;
  final Widget? body;
  final String? defaultHint;

  @override
  _TagSearchBarState createState() => _TagSearchBarState();
}

class _TagSearchBarState extends State<TagSearchBar> {
  final searchBarController = FloatingSearchBarController();
  var suggestionList = <SearchSuggestions>[];

  @override
  void initState() {
    super.initState();
    _onSearchTagChange();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: searchBarController,
      defaultHint: widget.searchText.isNotEmpty ? widget.searchText : 'CatPic',
      onSubmitted: (value) async {
        widget.onSearch(value.trim());
        _setSearchHistory(value.trim());
      },
      onFocusChanged: (isFocus) {
        _onSearchTagChange();
      },
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      body: widget.body,
      onQueryChanged: _onSearchTagChange,
      candidateBuilder: (ctx, _) {
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: suggestionList.map((e) {
              return ListTile(
                title: Text(e.title),
                onTap: () {
                  final newTag = searchBarController.query.split(' ')
                    ..removeLast()
                    ..add(e.title);
                  searchBarController.query = newTag.join(' ') + ' ';
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _onSearchTagChange([String? tag]) async {
    tag = tag ?? searchBarController.query;
    if (tag.isNotEmpty) {
      // 推荐Tag
      final lastTag = tag.split(' ').last;
      final dao = DatabaseHelper().tagDao;
      final list = await dao.getStart(mainStore.websiteEntity!.id, lastTag);
      setState(() {
        suggestionList = list.map((e) => SearchSuggestions(e.tag)).toList();
      });
    } else {
      // 历史搜索
      final dao = DatabaseHelper().historyDao;
      final list = await dao.getAll();
      setState(() {
        suggestionList = list
            .where((e) => e.history.trim().isNotEmpty)
            .map((e) => SearchSuggestions(e.history))
            .toList();
      });
    }
  }

  Future<void> _setSearchHistory(String tag) async {
    if (tag.isEmpty) return;
    final dao = DatabaseHelper().historyDao;
    final history = await dao.get(tag);
    if (history != null) {
      await dao.updateHistory(history.copyWith(createTime: DateTime.now()));
    } else {
      dao.insert(HistoryTableCompanion.insert(history: tag));
    }
  }
}
