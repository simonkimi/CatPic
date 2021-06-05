import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/history.dart';
import 'package:catpic/main.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class EhCompleteBar extends StatefulWidget {
  const EhCompleteBar({
    Key? key,
    this.onSubmitted,
    required this.searchText,
    required this.body,
    this.controller,
  }) : super(key: key);

  final ValueChanged<String>? onSubmitted;
  final String searchText;
  final Widget body;
  final FloatingSearchBarController? controller;

  @override
  _EhCompleteBarState createState() => _EhCompleteBarState();
}

class _EhCompleteBarState extends State<EhCompleteBar> {
  late final FloatingSearchBarController searchBarController =
      widget.controller ?? FloatingSearchBarController();

  var searchSuggestion = <SearchSuggestion>[];

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: searchBarController,
      searchText: widget.searchText,
      onSubmitted: (value) {
        _setSearchHistory(value.trim());
        widget.onSubmitted?.call(value);
      },
      onFocusChanged: (value) {
        _onSearchTagChange();
      },
      onQueryChanged: (value) {
        _onSearchTagChange(value);
      },
      body: widget.body,
      candidateBuilder: (BuildContext context, Animation<double> transition) {
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: searchSuggestion.map((e) {
              return ListTile(
                title: Text(e.title),
                subtitle: e.subTitle != null ? Text(e.subTitle!) : null,
                onTap: () {
                  final tag = e.title.contains(' ') && !e.isHistory
                      ? '"${e.title}\$"'
                      : e.title;
                  final newTag = searchBarController.query.split(' ')
                    ..removeLast()
                    ..add(tag);
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
    final fullTag = tag ?? searchBarController.query;

    final Iterable<HistoryTableData> history = (await DB().historyDao.getAll())
        .where((e) => e.type == HistoryType.EH)
        .where((e) => e.history.startsWith(tag!))
        .take(20);

    final String lastTag = fullTag.split(' ').last;
    final List<EhTranslateTableData> complete =
        lastTag.isEmpty || !settingStore.ehAutoCompute
            ? <EhTranslateTableData>[]
            : await DB().translateDao.getByTag(lastTag);

    setState(() {
      searchSuggestion = <SearchSuggestion>[
        ...history
            .map((e) => SearchSuggestion(title: e.history, isHistory: true)),
        ...complete.take(50).map((e) => SearchSuggestion(
              title: '${e.namespace.substring(0, 1)}:${e.name}',
              subTitle: e.translate,
            ))
      ];
    });
  }

  Future<void> _setSearchHistory(String tag) async {
    if (tag.isEmpty) {
      return;
    }
    final dao = DB().historyDao;
    final history = await dao.get(tag);
    if (history != null) {
      await dao.updateHistory(history.copyWith(createTime: DateTime.now()));
    } else {
      dao.insert(HistoryTableCompanion.insert(
        history: tag,
        type: HistoryType.EH,
      ));
    }
  }
}

class SearchSuggestion {
  const SearchSuggestion({
    required this.title,
    this.isHistory = false,
    this.subTitle,
  });

  final String title;
  final String? subTitle;
  final bool isHistory;
}
