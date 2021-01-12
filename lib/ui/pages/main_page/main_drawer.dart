import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Observer(
        builder: (context) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('E-Hentai'),
                accountEmail: Text('www.e-hentai.org'),
                currentAccountPicture: Icon(Icons.android),
                onDetailsPressed: () {},
                otherAccountsPictures: [],
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('主页'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.local_fire_department),
                title: Text('热门'),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('收藏'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('历史'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.download_rounded),
                title: Text('下载'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('设置'),
                onTap: () {},
              )
            ],
          );
        },
      ),
    );
  }
}
