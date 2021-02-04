import 'dart:math';

import 'package:flutter/material.dart';

class PostPreviewCard extends StatelessWidget {
  final String title;
  final String subTitle;

  const PostPreviewCard({Key key, this.title, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              color: Colors.accents[Random().nextInt(Colors.accents.length)][100],
              height: 100 + Random().nextInt(200).toDouble(),
            ),
            Text(title),
            Text(subTitle, style: TextStyle(
              color: Color(0xFF909399)
            ),)
          ],
        ),
      ),
    );
  }
}
