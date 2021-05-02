import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';

class BasicSearchBar extends StatefulWidget {
  const BasicSearchBar({
    Key? key,
    this.body,
    required this.onSearch,
    this.controller,
    this.searchText = 'CatPic',
    required this.historyType,
  }) : super(key: key);

  final Widget? body;
  final String searchText;
  final ValueChanged<String> onSearch;
  final FloatingSearchBarController? controller;
  final int historyType;

  @override
  _BasicSearchBarState createState() => _BasicSearchBarState();
}

class _BasicSearchBarState extends State<BasicSearchBar> {
  late final FloatingSearchBarController searchBarController =
      widget.controller ?? FloatingSearchBarController();
  var suggestionList = <SearchSuggestion>[];

  var lastClickBack = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: buildSearchBar(context),
      onWillPop: () async {
        if (Scaffold.of(context).isDrawerOpen) {
          return true;
        }
        if (searchBarController.isOpen) {
          searchBarController.close();
          return false;
        }
        final nowTime = DateTime.now();
        if (mainStore.searchPageCount <= 1 &&
            nowTime.difference(lastClickBack) > const Duration(seconds: 1)) {
          BotToast.showText(text: I18n.of(context).click_again_to_exit);
          lastClickBack = nowTime;
          return false;
        }
        return true;
      },
    );
  }

  SearchBar buildSearchBar(BuildContext context) {
    return SearchBar(
      body: widget.body,
      actions: [
        FloatingSearchBarAction.searchToClear(showIfClosed: false),
      ],
      onQueryChanged: (value) {
        _onSearchTagChange(value);
      },
      onSubmitted: (value) async {
        _setSearchHistory(value.trim());
        widget.onSearch(value.trim());
      },
      candidateBuilder: (ctx, _) {
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: suggestionList.map((e) {
              return ListTile(
                title: Text(e.title),
                subtitle: e.subTitle != null
                    ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              e.subTitle!,
                              style: TextStyle(color: e.color),
                            ),
                          ),
                          Text(
                            e.count.toString(),
                            style: Theme.of(context).textTheme.subtitle2,
                          )
                        ],
                      )
                    : null,
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
    final dao = DatabaseHelper().historyDao;
    final list =
        (await dao.getAll()).where((e) => e.type == widget.historyType);
    setState(() {
      suggestionList = list
          .where((e) => e.history.trim().isNotEmpty)
          .map((e) => SearchSuggestion(e.history))
          .toList();
    });
  }

  Future<void> _setSearchHistory(String tag) async {
    if (tag.isEmpty) return;
    final dao = DatabaseHelper().historyDao;
    final history = await dao.get(tag);
    if (history != null) {
      await dao.updateHistory(history.copyWith(createTime: DateTime.now()));
    } else {
      dao.insert(HistoryTableCompanion.insert(
        history: tag,
        type: widget.historyType,
      ));
    }
  }
}
