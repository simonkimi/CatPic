import 'package:catpic/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PostPreviewCard extends StatelessWidget {
  const PostPreviewCard({
    Key? key,
    required this.title,
    this.subTitle,
    required this.body,
    this.hasSize = false,
  }) : super(key: key);
  final String title;
  final String? subTitle;
  final Widget body;
  final bool hasSize;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final child = settingStore.showCardDetail
          ? Column(
              children: [
                if (hasSize) Expanded(child: body),
                if (!hasSize) body,
                Text(title),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    style: const TextStyle(color: Color(0xFF909399)),
                  )
              ],
            )
          : body;
      return settingStore.useCardWidget
          ? Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(5)),
              clipBehavior: Clip.antiAlias,
              child: child,
            )
          : child;
    });
  }
}
