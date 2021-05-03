import 'dart:convert';

import 'package:catpic/utils/utils.dart';

class Root {
  Root({
    required this.id,
    required this.createdAt,
    required this.postId,
    required this.creator,
    required this.creatorId,
    required this.body,
  });

  factory Root.fromJson(Map<String, dynamic> jsonRes) => Root(
        id: asT<int>(jsonRes['id'])!,
        createdAt: asT<String>(jsonRes['created_at'])!,
        postId: asT<int>(jsonRes['post_id'])!,
        creator: asT<String>(jsonRes['creator'])!,
        creatorId: asT<int>(jsonRes['creator_id'])!,
        body: asT<String>(jsonRes['body'])!,
      );

  int id;
  String createdAt;
  int postId;
  String creator;
  int creatorId;
  String body;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'created_at': createdAt,
        'post_id': postId,
        'creator': creator,
        'creator_id': creatorId,
        'body': body,
      };

  Root clone() =>
      Root.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
