import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  final String text;

  const SummaryTile(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
