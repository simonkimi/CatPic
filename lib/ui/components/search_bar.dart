import 'package:catpic/main.dart';
import 'package:catpic/themes.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchBarTmpController {
  SearchBarTmpController();

  SearchBarState? _state;

  String get tmp => _state?._searchTmp ?? '';

  void search() => _state?.search();

  set tmp(String value) {
    _state?.setTmp(value);
    _state?.onQueryChanged(value);
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    this.actions,
    this.controller,
    this.defaultHint,
    this.onSubmitted,
    this.onQueryChanged,
    this.searchText,
    this.debounceDelay = const Duration(milliseconds: 100),
    required this.candidateBuilder,
    this.body,
    this.onFocusChanged,
    this.progress,
    this.showTmp = false,
    this.tmpController,
  }) : super(key: key);

  final OnQueryChangedCallback? onSubmitted;
  final OnQueryChangedCallback? onQueryChanged;

  final FloatingSearchBarBuilder candidateBuilder;
  final List<Widget>? actions;
  final Widget? body;

  final FloatingSearchBarController? controller;
  final SearchBarTmpController? tmpController;
  final String? defaultHint;
  final String? searchText;
  final Duration debounceDelay;
  final OnFocusChangedCallback? onFocusChanged;
  final dynamic progress;
  final bool showTmp;

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  late var _searchText = widget.searchText ?? '';
  late var _searchTmp = widget.searchText ?? '';
  late FloatingSearchBarController controller;
  late String defaultHint;

  @override
  void initState() {
    super.initState();
    widget.tmpController?._state = this;
    controller = widget.controller ?? FloatingSearchBarController();
    defaultHint = widget.defaultHint ?? 'CatPic';
  }

  void setTmp(String value) {
    setState(() {
      _searchTmp = value;
    });
  }

  void search() {
    controller.close();
    widget.onSubmitted?.call(_searchTmp);
    setState(() {
      _searchText = _searchTmp;
    });
  }

  void onQueryChanged(String value) {
    widget.onQueryChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: widget.showTmp
          ? (_searchTmp.isEmpty ? defaultHint : _searchTmp)
          : (_searchText.isEmpty ? defaultHint : _searchText),
      backgroundColor:
          isDarkMode(context) ? const Color(0xFF424242) : Colors.white,
      controller: controller,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
      physics: const ClampingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      openWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 100),
      progress: widget.progress,
      automaticallyImplyDrawerHamburger: !Navigator.of(context).canPop(),
      leadingActions: [
        if (Navigator.of(context).canPop() && mainStore.searchPageCount > 1)
          FloatingSearchBarAction.back(),
      ],
      body: widget.body,
      onQueryChanged: (query) {
        if (controller.isOpen) {
          widget.onQueryChanged?.call(query);
          setState(() {
            _searchTmp = query;
          });
        }
      },
      onSubmitted: (query) {
        controller.close();
        widget.onSubmitted?.call(query);
        setState(() {
          _searchText = query;
        });
      },
      onFocusChanged: (isFocused) {
        widget.onFocusChanged?.call(isFocused);
        if (isFocused) {
          controller.query = _searchTmp;
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: widget.actions,
      builder: widget.candidateBuilder,
    );
  }
}

class SearchSuggestion {
  SearchSuggestion(this.title, {this.subTitle, this.count, this.color});

  final String title;
  final String? subTitle;
  final int? count;
  final Color? color;

  @override
  String toString() {
    return title;
  }
}
