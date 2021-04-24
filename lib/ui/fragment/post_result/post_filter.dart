import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class PostFilter extends StatelessWidget {
  const PostFilter({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final FloatingSearchBarController controller;

  @override
  Widget build(BuildContext context) {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Padding(
        padding: EdgeInsets.only(top: barHeight + 60, left: 4, right: 4),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Card(
            child: ListView(),
          ),
        ),
      ),
    );
  }
}
