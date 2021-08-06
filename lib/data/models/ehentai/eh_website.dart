import 'dart:typed_data';

import 'package:catpic/data/models/gen/eh_storage.pbenum.dart';
import 'package:flutter/material.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/basic.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/models/gen/eh_storage.pb.dart';

part 'eh_website.g.dart';

class EhWebsiteEntity = EhWebsiteEntityBase with _$EhWebsiteEntity;

abstract class EhWebsiteEntityBase with Store implements IWebsiteEntity {
  EhWebsiteEntityBase.build(this.database)
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
    initStorage();
  }

  EhWebsiteEntityBase.silent(this.database)
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
    initStorage();
  }

  WebsiteTableData database;

  late EHStorage eHStorage;

  late ObservableList<EhFavourite> favouriteList;

  @observable
  ReadAxis _readAxis = ReadAxis.leftToRight;

  set readAxis(ReadAxis value) {
    _readAxis = value;
    eHStorage.readAxis = value;
    storage = eHStorage.writeToBuffer();
    save();
  }

  @observable
  ScreenAxis _screenAxis = ScreenAxis.vertical;

  @observable
  DisplayType _displayType = DisplayType.Single;
  set displayType(DisplayType value) {
    _displayType = value;
    eHStorage.displayType = value;
    storage = eHStorage.writeToBuffer();
    save();
  }

  DisplayType get displayType => _displayType;

  @override
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
  @observable
  @override
  bool useDoH;
  @observable
  @override
  bool onlyHost;
  @observable
  @override
  bool directLink;
  @observable
  @override
  String cookies;
  @observable
  @override
  Uint8List favicon;
  @observable
  @override
  String? username;
  @observable
  @override
  String? password;
  @observable
  @override
  Uint8List storage;

  set screenAxis(ScreenAxis value) {
    _screenAxis = value;
    eHStorage.screenAxis = value;
    storage = eHStorage.writeToBuffer();
    save();
  }

  @computed
  ScreenAxis get screenAxis => _screenAxis;

  @computed
  ReadAxis get readAxis => _readAxis;



  void initStorage() {
    eHStorage = EHStorage.fromBuffer(storage);
    favouriteList = ObservableList.of(eHStorage.favourite.length != 10
        ? List.generate(
            10,
            (index) =>
                EhFavourite(favcat: index, count: 0, tag: 'Favorites $index'),
          )
        : eHStorage.favourite);
    _readAxis = eHStorage.readAxis;
    _screenAxis = eHStorage.screenAxis;
  }

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

extension EhFavouriteColor on int {
  Color get favcatColor {
    switch (this) {
      case 0:
        return Colors.black54;
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.green;
      case 5:
        return const Color(0xFFa1ee2d);
      case 6:
        return Colors.cyan;
      case 7:
        return Colors.blueAccent;
      case 8:
        return Colors.purple;
      case 9:
        return Colors.pink;
      case -1:
      default:
        return Colors.red;
    }
  }
}
