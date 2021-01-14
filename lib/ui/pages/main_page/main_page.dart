import 'package:catpic/ui/components/main_drawer.dart';
import 'package:catpic/ui/pages/main_page/store/main_store.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MainPage extends StatefulWidget {
  static String routeName = "MainPage";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (_) => Text(mainStore.websiteEntity?.name ?? 'CatPic'),
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: '菜单',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            tooltip: '搜索',
          )
        ],
      ),
      drawer: MainDrawer(),
    );
  }

  @override
  void initState() {
    super.initState();
    EventBusUtil().bus.on<EventSiteChange>().listen((event) {
      mainStore.updateList();
    });
  }
}
