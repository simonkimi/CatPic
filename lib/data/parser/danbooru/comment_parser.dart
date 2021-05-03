import 'dart:convert';
import 'package:catpic/data/models/booru/booru_comment.dart';

import 'comment_model.dart';

class DanbooruCommentParser {
  static List<BooruComments> parse(String str) {
    final List<dynamic> comments = jsonDecode(str);
    return comments
        .map((e) => Root.fromJson(e))
        .where((e) => e.body != null)
        .map((e) {
      return BooruComments(
        id: e.id.toString(),
        body: e.body!,
        createAt: e.updatedAt,
        creator: e.updaterId.toString(),
      );
    }).toList();
  }
}
