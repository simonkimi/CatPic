import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/data/models/booru/booru_website.dart';
import 'package:catpic/data/models/ehentai/eh_website.dart';
import 'package:moor/moor.dart';

abstract class IWebsiteEntity {
  static IWebsiteEntity? build(WebsiteTableData? db) {
    if (db == null) return null;
    if (db.type == WebsiteType.EHENTAI) return EhWebsiteEntity.build(db);
    return BooruWebsiteEntity.build(db);
  }

  static IWebsiteEntity? silent(WebsiteTableData? db) {
    if (db == null) return null;
    if (db.type == WebsiteType.EHENTAI) return EhWebsiteEntity.silent(db);
    return BooruWebsiteEntity.silent(db);
  }

  late int id;

  late String name;

  late String host;

  late int scheme;

  late int type;

  late bool useDoH;

  late bool onlyHost;

  late bool directLink;

  late String cookies;

  late Uint8List favicon;

  late String? username;

  late String? password;

  late Uint8List storage;

  Future<void> save();
}
