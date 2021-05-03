import 'dart:convert';
import 'package:catpic/utils/utils.dart';

class PoolList {
  PoolList({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.isActive,
    required this.isDeleted,
    required this.postIds,
    required this.category,
    required this.postCount,
  });

  factory PoolList.fromJson(Map<String, dynamic> jsonRes) {
    final List<int>? postIds = jsonRes['post_ids'] is List ? <int>[] : null;
    if (postIds != null) {
      for (final dynamic item in jsonRes['post_ids']!) {
        if (item != null) {
          postIds.add(asT<int>(item)!);
        }
      }
    }
    return PoolList(
      id: asT<int>(jsonRes['id'])!,
      name: asT<String>(jsonRes['name'])!,
      createdAt: asT<String>(jsonRes['created_at'])!,
      updatedAt: asT<String>(jsonRes['updated_at'])!,
      description: asT<String>(jsonRes['description'])!,
      isActive: asT<bool>(jsonRes['is_active'])!,
      isDeleted: asT<bool>(jsonRes['is_deleted'])!,
      postIds: postIds!,
      category: asT<String>(jsonRes['category'])!,
      postCount: asT<int>(jsonRes['post_count'])!,
    );
  }

  int id;
  String name;
  String createdAt;
  String updatedAt;
  String description;
  bool isActive;
  bool isDeleted;
  List<int> postIds;
  String category;
  int postCount;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'description': description,
        'is_active': isActive,
        'is_deleted': isDeleted,
        'post_ids': postIds,
        'category': category,
        'post_count': postCount,
      };

  PoolList clone() => PoolList.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
