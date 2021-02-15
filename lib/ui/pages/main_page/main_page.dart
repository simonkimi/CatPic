import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:catpic/ui/store/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class MainPage extends StatefulWidget {
  static String routeName = 'MainPage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String data;
  List<SearchSuggestions> suggestion;
  final FloatingSearchBarController _controller = FloatingSearchBarController();

  @override
  void initState() {
    super.initState();
    data = '';
    suggestion = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(),
            FloatingSearchBar(
              controller: _controller,
              builder: _builder,
              debounceDelay: const Duration(milliseconds: 100),
              scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
              transitionDuration: const Duration(milliseconds: 300),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              axisAlignment: 0,
              openAxisAlignment: 0.0,
              maxWidth: 600,
              transition: CircularFloatingSearchBarTransition(),
              onQueryChanged: _queryTag,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _queryTag(String tags) async {
    if (tags.trim().isEmpty) {
      // TODO 历史记录

    } else {
      final lastTag = tags.trim().split(' ').where((e) => e.isNotEmpty).last;
      final dao = DatabaseHelper().tagDao;
      final list = await dao.getStart(mainStore.websiteEntity.id, '$lastTag%');
      final suggestions = list.map((e) => SearchSuggestions(e.tag));
      setState(() {
        suggestion = suggestions.toList();
      });
    }
  }

  Widget _builder(BuildContext context, Animation<double> transition) {
    return Material(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      animationDuration: Duration(seconds: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: suggestion.map((e) {
          return ListTile(
            title: Text(e.title),
            onTap: () {
              _controller.query = e.title;
            },
          );
        }).toList(),
      ),
    );
  }
}
