import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class EhComment extends StatelessWidget {
  const EhComment({
    Key? key,
    this.displayVote = false,
    required this.model,
    this.maxLine,
    this.onTap,
    this.onOpen,
  }) : super(key: key);

  final bool displayVote;
  final CommentModel model;
  final int? maxLine;
  final VoidCallback? onTap;
  final LinkCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      model.username,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle2!.color,
                      ),
                    ),
                    if (model.score != -99999 && displayVote)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            (model.score >= 0 ? '   +' : '   ') +
                                model.score.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  Theme.of(context).textTheme.subtitle2!.color,
                            ),
                          )
                        ],
                      ),
                  ],
                ),
                Text(
                  model.commentTime,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.subtitle2!.color,
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableLinkify(
                  text: model.comment,
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  options: const LinkifyOptions(humanize: false),
                  maxLines: maxLine,
                  minLines: 1,
                  onTap: onTap,
                  onOpen: onOpen,
                  linkStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
