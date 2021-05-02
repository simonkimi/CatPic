import 'dart:convert';

import 'package:catpic/utils/utils.dart';

class Root {
  Root({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.updatedAt,
    required this.isDeleted,
    required this.groupName,
    required this.isBanned,
    required this.otherNames,
  });

  factory Root.fromJson(Map<String, dynamic> jsonRes) {
    final List<String>? otherNames =
        jsonRes['other_names'] is List ? <String>[] : null;
    if (otherNames != null) {
      for (final dynamic item in jsonRes['other_names']!) {
        if (item != null) {
          tryCatch(() {
            otherNames.add(asT<String>(item)!);
          });
        }
      }
    }
    return Root(
      id: asT<int>(jsonRes['id'])!,
      createdAt: asT<String>(jsonRes['created_at'])!,
      name: asT<String>(jsonRes['name'])!,
      updatedAt: asT<String>(jsonRes['updated_at'])!,
      isDeleted: asT<bool>(jsonRes['is_deleted'])!,
      groupName: asT<String>(jsonRes['group_name'])!,
      isBanned: asT<bool>(jsonRes['is_banned'])!,
      otherNames: otherNames!,
    );
  }

  int id;
  String createdAt;
  String name;
  String updatedAt;
  bool isDeleted;
  String groupName;
  bool isBanned;
  List<String> otherNames;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'created_at': createdAt,
        'name': name,
        'updated_at': updatedAt,
        'is_deleted': isDeleted,
        'group_name': groupName,
        'is_banned': isBanned,
        'other_names': otherNames,
      };

  Root clone() =>
      Root.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
