import 'dart:convert';

import 'package:catpic/utils/utils.dart';

class Root {
  Root({
    required this.id,
    required this.createdAt,
    required this.postId,
    this.creatorId,
    this.body,
    required this.score,
    required this.updatedAt,
    this.updaterId,
    required this.doNotBumpPost,
    required this.isDeleted,
    required this.isSticky,
  });

  factory Root.fromJson(Map<String, dynamic> jsonRes) => Root(
        id: asT<int>(jsonRes['id'])!,
        createdAt: asT<String>(jsonRes['created_at'])!,
        postId: asT<int>(jsonRes['post_id'])!,
        creatorId: asT<int?>(jsonRes['creator_id']),
        body: asT<String?>(jsonRes['body']),
        score: asT<int>(jsonRes['score'])!,
        updatedAt: asT<String>(jsonRes['updated_at'])!,
        updaterId: asT<int?>(jsonRes['updater_id']),
        doNotBumpPost: asT<bool>(jsonRes['do_not_bump_post'])!,
        isDeleted: asT<bool>(jsonRes['is_deleted'])!,
        isSticky: asT<bool>(jsonRes['is_sticky'])!,
      );

  int id;
  String createdAt;
  int postId;
  int? creatorId;
  String? body;
  int score;
  String updatedAt;
  int? updaterId;
  bool doNotBumpPost;
  bool isDeleted;
  bool isSticky;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'created_at': createdAt,
        'post_id': postId,
        'creator_id': creatorId,
        'body': body,
        'score': score,
        'updated_at': updatedAt,
        'updater_id': updaterId,
        'do_not_bump_post': doNotBumpPost,
        'is_deleted': isDeleted,
        'is_sticky': isSticky,
      };

  Root clone() =>
      Root.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
