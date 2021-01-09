import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Hentai"),
        backgroundColor: Theme.of(context).appBarTheme.color,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: "菜单",
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            tooltip: "搜索",
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("E-Hentai"),
              accountEmail: Text("www.e-hentai.org"),
              currentAccountPicture: Icon(Icons.android),
              onDetailsPressed: () {},
              otherAccountsPictures: [],
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("主页"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("主页"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("主页"),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
