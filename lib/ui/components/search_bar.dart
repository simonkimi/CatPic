import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchBar extends StatefulWidget {
  final OnQueryChangedCallback onSubmitted;
  final FloatingSearchBarBuilder candidateBuilder;
  final List<Widget> actions;

  final FloatingSearchBarController controller;
  final String defaultHint;

  SearchBar({
    Key key,
    this.actions,
    this.controller,
    this.defaultHint,
    this.onSubmitted,
    @required this.candidateBuilder,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  var searchText = '';
  var searchTmp = '';
  FloatingSearchBarController controller;
  String defaultHint;


  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? FloatingSearchBarController();
    defaultHint = widget.defaultHint ?? 'CatPic';
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;
    return FloatingSearchBar(
      hint: searchText.isEmpty ? defaultHint : searchText,
      controller: controller,
      scrollPadding: EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
      physics: BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: Duration(milliseconds: 100),
      onQueryChanged: (query) {
        if (controller.isOpen) {
          setState(() {
            searchTmp = query;
          });
        }
      },
      onSubmitted: (query) {
        controller.close();
        if (widget.onSubmitted != null) {
          widget.onSubmitted(query);
        }
        setState(() {
          searchText = query;
        });
      },
      onFocusChanged: (isFocused) {
        if (isFocused) {
          controller.query = searchTmp;
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: widget.actions,
      builder: widget.candidateBuilder,
    );
  }
}
