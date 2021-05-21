import 'package:catpic/data/models/ehentai/gallery_model.dart';
import 'package:flutter/material.dart';

class EhComment extends StatelessWidget {
  const EhComment({
    Key? key,
    this.displayVote = false,
    required this.model,
  }) : super(key: key);

  final bool displayVote;
  final CommentModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.username,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle2!.color,
                  ),
                ),
                Text(
                  model.commentTime,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.subtitle2!.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            if (!displayVote)
              Text(
                model.comment,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            if (displayVote)
              RichText(
                text: TextSpan(
                  text: model.comment,
                  style: Theme.of(context).textTheme.bodyText2,
                  children: [
                    if (model.score != -99999)
                      TextSpan(
                        text: (model.score >= 0 ? '   +' : '   ') +
                            model.score.toString(),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle2!.color,
                        ),
                      )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
