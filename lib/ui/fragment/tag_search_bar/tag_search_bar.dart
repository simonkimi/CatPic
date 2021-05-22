import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/history.dart';
import 'package:catpic/main.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/fragment/tag_search_bar/post_filter.dart';
import 'package:catpic/ui/fragment/tag_search_bar/store/filter_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:catpic/data/models/booru/booru_tag.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:catpic/utils/utils.dart';

import 'package:catpic/i18n.dart';

class TagSearchBar extends StatefulWidget {
  const TagSearchBar({
    Key? key,
    this.searchText = 'CatPic',
    required this.onSearch,
    this.body,
    this.defaultHint,
    this.onTextChange,
    this.controller,
    this.tmpController,
  }) : super(key: key);

  final ValueChanged<String> onSearch;
  final ValueChanged<String>? onTextChange;
  final String searchText;
  final Widget? body;
  final String? defaultHint;
  final FloatingSearchBarController? controller;
  final SearchBarTmpController? tmpController;

  @override
  _TagSearchBarState createState() => _TagSearchBarState();
}

class _TagSearchBarState extends State<TagSearchBar>
    with TickerProviderStateMixin {
  late final FloatingSearchBarController searchBarController =
      widget.controller ?? FloatingSearchBarController();

  late SearchBarTmpController tmpController =
      widget.tmpController ?? SearchBarTmpController();

  late final actionController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> actionAnimation =
      Tween<double>(begin: 0.0, end: 0.375).animate(actionController);

  late final filterStore = FilterStore(widget.searchText);

  var suggestionList = <SearchSuggestion>[];
  var loadingProgress = false;
  CancelToken? cancelToken;
  var filterDisplaySwitch = false;
  var lastClickBack = DateTime.now();

  @override
  void initState() {
    super.initState();
    _onSearchTagChange();
  }

  void onActionPress() {
    if (searchBarController.query.isNotEmpty) {
      searchBarController.clear();
    } else if (searchBarController.isOpen) {
      searchBarController.close();
    } else {
      if (!filterDisplaySwitch) {
        // 当前为搜索页面
        setState(() {
          filterDisplaySwitch = true;
        });
        actionController.forward();
      } else {
        backToSearch();
      }
    }
  }

  void backToSearch([Function? callBack]) {
    setState(() {
      filterDisplaySwitch = false;
    });
    actionController.reverse();
    callBack?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          if (Scaffold.of(context).isDrawerOpen) {
            return true;
          }
          if (searchBarController.isOpen) {
            searchBarController.close();
            return false;
          }
          if (filterDisplaySwitch) {
            backToSearch();
            return false;
          }
          final nowTime = DateTime.now();
          if (mainStore.searchPageCount <= 1 &&
              nowTime.difference(lastClickBack) > const Duration(seconds: 2)) {
            BotToast.showText(text: I18n.g.click_again_to_exit);
            lastClickBack = nowTime;
            return false;
          }
          return true;
        },
        child: buildSearchBar(context),
      );
    });
  }

  SearchBar buildSearchBar(BuildContext context) {
    return SearchBar(
      progress: loadingProgress,
      controller: searchBarController,
      tmpController: widget.tmpController,
      searchText: widget.searchText,
      defaultHint: widget.searchText.isNotEmpty ? widget.searchText : 'CatPic',
      showTmp: filterDisplaySwitch,
      onSubmitted: (value) async {
        backToSearch(() {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            widget.onSearch(value.trim());
            _setSearchHistory(value.trim());
          });
        });
      },
      onFocusChanged: (isFocus) {
        _onSearchTagChange();
        if (!filterDisplaySwitch) {
          actionController.play(isFocus);
        }
      },
      actions: [
        FloatingSearchBarAction(
          showIfOpened: true,
          showIfClosed: true,
          child: RotationTransition(
            alignment: Alignment.center,
            turns: actionAnimation,
            child: CircularButton(
              icon: const Icon(Icons.add),
              onPressed: onActionPress,
            ),
          ),
        ),
      ],
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
                controller: searchBarController,
                tmpController: tmpController,
                store: filterStore,
              )
            : widget.body,
      ),
      onQueryChanged: (value) {
        _onSearchTagChange(value);
        filterStore.setSearchText(value);
        widget.onTextChange?.call(value);
      },
      debounceDelay: settingStore.autoCompleteUseNetwork
          ? const Duration(seconds: 2)
          : const Duration(seconds: 1),
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

  Future<List<SearchSuggestion>> _getTagSuggestions(String tag) async {
    if (settingStore.autoCompleteUseNetwork) {
      try {
        cancelToken?.cancel();
        cancelToken = CancelToken();
        setState(() {
          if (mounted) loadingProgress = true;
        });
        final adapter = BooruAdapter.fromWebsite(mainStore.websiteEntity!);
        final onlineTag = await adapter.tagList(
          name: tag,
          page: 1,
          limit: 100,
          cancelToken: cancelToken,
        );
        setState(() {
          if (mounted) loadingProgress = false;
        });
        return onlineTag
            .map((e) => SearchSuggestion(
                  e.name,
                  subTitle: e.type.string,
                  count: e.count,
                  color: e.type.color,
                ))
            .toList();
      } on DioError catch (e) {
        if (!CancelToken.isCancel(e)) {
          BotToast.showText(text: e.toString());
        }
      }
      return [];
    } else {
      final dao = DB().tagDao;
      final list = await dao.getStart(mainStore.websiteEntity!.id, tag);
      return list.map((e) => SearchSuggestion(e.tag)).toList();
    }
  }

  Future<void> _onSearchTagChange([String? tag]) async {
    tag = tag ?? searchBarController.query;
    if (tag.isNotEmpty) {
      // 推荐Tag
      final lastTag = tag.split(' ').last;
      if (lastTag.isEmpty) {
        setState(() {
          suggestionList = [];
        });
        return;
      }
      final list = await _getTagSuggestions(lastTag);
      setState(() {
        suggestionList = list;
      });
    } else {
      // 历史搜索
      final dao = DB().historyDao;
      final list = (await dao.getAll())
          .where((e) => e.type == HistoryType.POST)
          .toList();
      setState(() {
        suggestionList = list
            .where((e) => e.history.trim().isNotEmpty)
            .map((e) => SearchSuggestion(e.history))
            .toList();
      });
    }
  }

  Future<void> _setSearchHistory(String tag) async {
    if (tag.isEmpty) return;
    final dao = DB().historyDao;
    final history = await dao.get(tag);
    if (history != null) {
      await dao.updateHistory(history.copyWith(createTime: DateTime.now()));
    } else {
      dao.insert(HistoryTableCompanion.insert(
        history: tag,
        type: HistoryType.POST,
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelToken?.cancel();
  }
}
