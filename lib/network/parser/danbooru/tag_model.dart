import 'dart:convert';

import 'package:catpic/utils/utils.dart';

class Root {
  Root({
    required this.id,
    required this.name,
    required this.postCount,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.isLocked,
  });

  factory Root.fromJson(Map<String, dynamic> jsonRes) => Root(
        id: asT<int>(jsonRes['id'])!,
        name: asT<String>(jsonRes['name'])!,
        postCount: asT<int>(jsonRes['post_count'])!,
        category: asT<int>(jsonRes['category'])!,
        createdAt: asT<String>(jsonRes['created_at'])!,
        updatedAt: asT<String>(jsonRes['updated_at'])!,
        isLocked: asT<bool>(jsonRes['is_locked'])!,
      );

  int id;
  String name;
  int postCount;
  int category;
  String createdAt;
  String updatedAt;
  bool isLocked;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'post_count': postCount,
        'category': category,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'is_locked': isLocked,
      };

  Root clone() =>
      Root.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
