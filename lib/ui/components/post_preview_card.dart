import 'package:flutter/material.dart';

class PostPreviewCard extends StatelessWidget {
  const PostPreviewCard({Key key, this.title, this.subTitle, this.body})
      : super(key: key);
  final String title;
  final String subTitle;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          body,
          Text(title),
          Text(
            subTitle,
            style: const TextStyle(color: Color(0xFF909399)),
          )
        ],
      ),
    );
  }
}
