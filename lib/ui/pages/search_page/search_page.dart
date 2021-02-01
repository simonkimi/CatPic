import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var searchBarController = FloatingSearchBarController();
  var searchText = '';
  var searchTmp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [buildFloatingSearchBar(context)],
      ),
    );
  }

  Widget buildFloatingSearchBar(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      hint: searchText.isEmpty? 'CatPic': searchText,
      scrollPadding: EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
      physics: BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: Duration(milliseconds: 100),
      onQueryChanged: (query) {
        if (searchBarController.isOpen) {
          setState(() {
            searchTmp = query;
          });
        }
      },
      onSubmitted: (query) {
        searchBarController.close();
        setState(() {
          searchText = query;
        });
      },
      onFocusChanged: (isFocused) {
        if (isFocused) {
          searchBarController.query = searchTmp;
        }
      },

      controller: searchBarController,
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
