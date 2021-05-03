import 'dart:convert';

import 'package:catpic/utils/utils.dart';

class Root {
  Root({
    required this.id,
    required this.artistId,
    required this.name,
    required this.updaterId,
    required this.urls,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.groupName,
    required this.isBanned,
    required this.otherNames,
  });

  factory Root.fromJson(Map<String, dynamic> jsonRes) {
    final List<String>? urls = jsonRes['urls'] is List ? <String>[] : null;
    if (urls != null) {
      for (final dynamic item in jsonRes['urls']!) {
        if (item != null) {
          tryCatch(() {
            urls.add(asT<String>(item)!);
          });
        }
      }
    }

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
      artistId: asT<int>(jsonRes['artist_id'])!,
      name: asT<String>(jsonRes['name'])!,
      updaterId: asT<int>(jsonRes['updater_id'])!,
      urls: urls!,
      createdAt: asT<String>(jsonRes['created_at'])!,
      updatedAt: asT<String>(jsonRes['updated_at'])!,
      isDeleted: asT<bool>(jsonRes['is_deleted'])!,
      groupName: asT<String>(jsonRes['group_name'])!,
      isBanned: asT<bool>(jsonRes['is_banned'])!,
      otherNames: otherNames!,
    );
  }

  int id;
  int artistId;
  String name;
  int updaterId;
  List<String> urls;
  String createdAt;
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
        'artist_id': artistId,
        'name': name,
        'updater_id': updaterId,
        'urls': urls,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'is_deleted': isDeleted,
        'group_name': groupName,
        'is_banned': isBanned,
        'other_names': otherNames,
      };

  Root clone() =>
      Root.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
