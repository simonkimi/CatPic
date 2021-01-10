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
          );
        },
      ),
    );
  }
}
