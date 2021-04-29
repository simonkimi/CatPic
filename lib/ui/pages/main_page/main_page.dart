import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static String routeName = 'MainPage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
