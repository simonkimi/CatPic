import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static String routeName = "MainPage";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
    );
  }
}
