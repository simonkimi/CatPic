import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:get/get.dart';

class SearchBar extends StatelessWidget {
  final OnQueryChangedCallback onSubmitted;
  final FloatingSearchBarBuilder candidateBuilder;
  final List<Widget> actions;
  final Widget body;

  final FloatingSearchBarController controller;
  final String defaultHint;

  const SearchBar({
    Key key,
    this.onSubmitted,
    this.candidateBuilder,
    this.actions,
    this.body,
    this.controller,
    this.defaultHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GetX<SearchBarController>(
      init: SearchBarController(controller),
      builder: (c) => FloatingSearchBar(
        hint: c.searchText.value.isEmpty
            ? (defaultHint ?? 'CatPic')
            : c.searchText.value,
        controller: c.controller.value,
        scrollPadding: EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: Duration(milliseconds: 300),
        transitionCurve: Curves.easeInOut,
        physics: BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        maxWidth: isPortrait ? 600 : 500,
        debounceDelay: Duration(milliseconds: 100),
        body: body,
        onQueryChanged: (query) {
          if (c.controller.value.isOpen) {
            c.searchTmp.value = query;
          }
        },
        onSubmitted: (query) {
          c.controller.value.close();
          if (onSubmitted != null) {
            onSubmitted(query);
          }
          c.searchText.value = query;
        },
        onFocusChanged: (isFocused) {
          if (isFocused) {
            c.controller.value.query = c.searchTmp.value;
          }
        },
        transition: CircularFloatingSearchBarTransition(),
        actions: actions,
        builder: candidateBuilder,
      ),
    );
  }
}

class SearchBarController extends GetxController {
  var searchText = ''.obs;
  var searchTmp = ''.obs;
  var controller = Rx<FloatingSearchBarController>();

  SearchBarController(FloatingSearchBarController controller) {
    this.controller = controller?.obs ?? FloatingSearchBarController().obs;
  }
}
