import 'dart:convert';
import 'package:catpic/data/models/booru/booru_comment.dart';

import 'comment_model.dart';

class MoebooruCommentParser {
  static List<BooruComments> parse(String str) {
    final List<dynamic> comments = jsonDecode(str);
    return comments.map((e) => Root.fromJson(e)).map((e) {
      return BooruComments(
        id: e.id.toString(),
        body: e.body,
        createAt: e.createdAt,
        creator: e.creator,
      );
    }).toList();
  }
}
