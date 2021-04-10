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
    this.debounceDelay,
    required this.candidateBuilder,
    this.body,
    this.onFocusChanged,
  }) : super(key: key);

  final OnQueryChangedCallback? onSubmitted;
  final OnQueryChangedCallback? onQueryChanged;

  final FloatingSearchBarBuilder candidateBuilder;
  final List<Widget>? actions;
  final Widget? body;

  final FloatingSearchBarController? controller;
  final String? defaultHint;
  final Duration? debounceDelay;
  final OnFocusChangedCallback? onFocusChanged;

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
      hint: _searchText.isEmpty ? defaultHint : _searchText,
      controller: controller,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
      physics: const ClampingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      openWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 100),
      body: widget.body,
      onQueryChanged: (query) {
        if (widget.onQueryChanged != null) {
          widget.onQueryChanged!(query);
        }
        if (controller.isOpen) {
          setState(() {
            _searchTmp = query;
          });
        }
      },
      onSubmitted: (query) {
        controller.close();
        if (widget.onSubmitted != null) {
          widget.onSubmitted!(query);
        }
        setState(() {
          _searchText = query;
        });
      },
      onFocusChanged: (isFocused) {
        if (widget.onFocusChanged != null) {
          widget.onFocusChanged!(isFocused);
        }
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

class SearchSuggestions {
  SearchSuggestions(this.title, [this.subTitle]);

  final String title;
  final String? subTitle;
}
