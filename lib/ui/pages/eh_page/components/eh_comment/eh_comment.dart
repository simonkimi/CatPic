import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  options: const LinkifyOptions(humanize: false),
                  onOpen: (link) async {
                    // TODO 打开同站
                    if (await canLaunch(link.url)) {
                      await launch(link.url);
                    } else {
                      throw 'Could not launch $link';
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
