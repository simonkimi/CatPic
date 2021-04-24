import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    this.actions,
    this.controller,
    this.defaultHint,
    this.onSubmitted,
    this.onQueryChanged,
    this.debounceDelay = const Duration(milliseconds: 100),
    required this.candidateBuilder,
    this.body,
    this.onFocusChanged,
    this.progress,
    this.showTmp = false,
  }) : super(key: key);

  final OnQueryChangedCallback? onSubmitted;
  final OnQueryChangedCallback? onQueryChanged;

  final FloatingSearchBarBuilder candidateBuilder;
  final List<Widget>? actions;
  final Widget? body;

  final FloatingSearchBarController? controller;
  final String? defaultHint;
  final Duration debounceDelay;
  final OnFocusChangedCallback? onFocusChanged;
  final dynamic progress;
  final bool showTmp;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  var _searchText = '';
  var _searchTmp = '';
  late FloatingSearchBarController controller;
  late String defaultHint;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? FloatingSearchBarController();
    defaultHint = widget.defaultHint ?? 'CatPic';
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: widget.showTmp
          ? (_searchTmp.isEmpty ? defaultHint : _searchTmp)
          : (_searchText.isEmpty ? defaultHint : _searchText),
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
