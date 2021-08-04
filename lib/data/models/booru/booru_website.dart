import 'dart:typed_data';
import 'package:catpic/data/database/database.dart';
import 'package:mobx/mobx.dart';
import '../basic.dart';

part 'booru_website.g.dart';

class BooruWebsiteEntity = BooruWebsiteEntityBase with _$BooruWebsiteEntity;

abstract class BooruWebsiteEntityBase with Store implements IWebsiteEntity {
  BooruWebsiteEntityBase.build(this.database)
      : id = database.id,
        name = database.name,
        host = database.host,
        scheme = database.scheme,
        type = database.type,
        useDoH = database.useDoH,
        onlyHost = database.onlyHost,
        directLink = database.directLink,
        cookies = database.cookies,
        favicon = database.favicon,
        username = database.username,
        password = database.password,
        storage = database.storage ?? Uint8List.fromList([]) {
    DB()
        .websiteDao
        .replace(database.copyWith(lastOpen: DateTime.now().millisecond));
  }

  BooruWebsiteEntityBase.silent(this.database)
      : id = database.id,
        name = database.name,
        host = database.host,
        scheme = database.scheme,
        type = database.type,
        useDoH = database.useDoH,
        onlyHost = database.onlyHost,
        directLink = database.directLink,
        cookies = database.cookies,
        favicon = database.favicon,
        username = database.username,
        password = database.password,
        storage = database.storage ?? Uint8List.fromList([]);

  WebsiteTableData database;

  @override
  @observable
  int id;

  @override
  @observable
  String name;
  @override
  @observable
  String host;
  @override
  @observable
  int scheme;
  @override
  @observable
  int type;
  @override
  @observable
  bool useDoH;
  @override
  @observable
  bool onlyHost;
  @override
  @observable
  bool directLink;
  @override
  @observable
  String cookies;
  @override
  @observable
  Uint8List favicon;
  @override
  @observable
  String? username;
  @override
  @observable
  String? password;
  @override
  @observable
  Uint8List storage;

  @override
  Future<void> save() => DB().websiteDao.replace(database.copyWith(
        name: name,
        cookies: cookies,
        directLink: directLink,
        favicon: favicon,
        host: host,
        onlyHost: onlyHost,
        password: password,
        scheme: scheme,
        storage: storage,
        type: type,
        useDoH: useDoH,
        username: username,
      ));
}
