import 'package:catpic/data/database/database.dart';
import 'package:moor/moor.dart';
import 'package:mobx/mobx.dart';

part 'basic.g.dart';

class WebsiteEntity = WebsiteEntityBase with _$WebsiteEntity;

abstract class WebsiteEntityBase with Store {
  WebsiteEntityBase.build(this.database)
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

  WebsiteEntityBase.silent(this.database)
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
  final int id;
  @observable
  String name;
  @observable
  String host;
  @observable
  int scheme;
  @observable
  int type;
  @observable
  bool useDoH;
  @observable
  bool onlyHost;
  @observable
  bool directLink;
  @observable
  String cookies;
  @observable
  Uint8List favicon;
  @observable
  String? username;
  @observable
  String? password;
  @observable
  Uint8List storage;

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
