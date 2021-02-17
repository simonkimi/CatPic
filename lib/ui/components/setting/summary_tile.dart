import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  const SummaryTile(this.text, {Key key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const SizedBox(
        width: 10,
        height: 10,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
