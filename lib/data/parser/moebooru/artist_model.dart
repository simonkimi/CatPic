import 'dart:convert';
import 'package:catpic/utils/utils.dart';

class Root {
  Root({
    required this.id,
    required this.name,
    this.aliasId,
    this.groupId,
    required this.urls,
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
    return Root(
      id: asT<int>(jsonRes['id'])!,
      name: asT<String>(jsonRes['name'])!,
      aliasId: asT<int?>(jsonRes['alias_id']),
      groupId: asT<int?>(jsonRes['group_id']),
      urls: urls!,
    );
  }

  int id;
  String name;
  int? aliasId;
  int? groupId;
  List<String> urls;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'alias_id': aliasId,
        'group_id': groupId,
        'urls': urls,
      };

  Root clone() =>
      Root.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
