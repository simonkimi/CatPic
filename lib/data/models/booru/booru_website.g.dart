// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booru_website.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BooruWebsiteEntity on BooruWebsiteEntityBase, Store {
  final _$idAtom = Atom(name: 'BooruWebsiteEntityBase.id');

  @override
  int get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(int value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  final _$nameAtom = Atom(name: 'BooruWebsiteEntityBase.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$hostAtom = Atom(name: 'BooruWebsiteEntityBase.host');

  @override
  String get host {
    _$hostAtom.reportRead();
    return super.host;
  }

  @override
  set host(String value) {
    _$hostAtom.reportWrite(value, super.host, () {
      super.host = value;
    });
  }

  final _$schemeAtom = Atom(name: 'BooruWebsiteEntityBase.scheme');

  @override
  int get scheme {
    _$schemeAtom.reportRead();
    return super.scheme;
  }

  @override
  set scheme(int value) {
    _$schemeAtom.reportWrite(value, super.scheme, () {
      super.scheme = value;
    });
  }

  final _$typeAtom = Atom(name: 'BooruWebsiteEntityBase.type');

  @override
  int get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(int value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  final _$useDoHAtom = Atom(name: 'BooruWebsiteEntityBase.useDoH');

  @override
  bool get useDoH {
    _$useDoHAtom.reportRead();
    return super.useDoH;
  }

  @override
  set useDoH(bool value) {
    _$useDoHAtom.reportWrite(value, super.useDoH, () {
      super.useDoH = value;
    });
  }

  final _$onlyHostAtom = Atom(name: 'BooruWebsiteEntityBase.onlyHost');

  @override
  bool get onlyHost {
    _$onlyHostAtom.reportRead();
    return super.onlyHost;
  }

  @override
  set onlyHost(bool value) {
    _$onlyHostAtom.reportWrite(value, super.onlyHost, () {
      super.onlyHost = value;
    });
  }

  final _$directLinkAtom = Atom(name: 'BooruWebsiteEntityBase.directLink');

  @override
  bool get directLink {
    _$directLinkAtom.reportRead();
    return super.directLink;
  }

  @override
  set directLink(bool value) {
    _$directLinkAtom.reportWrite(value, super.directLink, () {
      super.directLink = value;
    });
  }

  final _$cookiesAtom = Atom(name: 'BooruWebsiteEntityBase.cookies');

  @override
  String get cookies {
    _$cookiesAtom.reportRead();
    return super.cookies;
  }

  @override
  set cookies(String value) {
    _$cookiesAtom.reportWrite(value, super.cookies, () {
      super.cookies = value;
    });
  }

  final _$faviconAtom = Atom(name: 'BooruWebsiteEntityBase.favicon');

  @override
  Uint8List get favicon {
    _$faviconAtom.reportRead();
    return super.favicon;
  }

  @override
  set favicon(Uint8List value) {
    _$faviconAtom.reportWrite(value, super.favicon, () {
      super.favicon = value;
    });
  }

  final _$usernameAtom = Atom(name: 'BooruWebsiteEntityBase.username');

  @override
  String? get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String? value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  final _$passwordAtom = Atom(name: 'BooruWebsiteEntityBase.password');

  @override
  String? get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String? value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$storageAtom = Atom(name: 'BooruWebsiteEntityBase.storage');

  @override
  Uint8List get storage {
    _$storageAtom.reportRead();
    return super.storage;
  }

  @override
  set storage(Uint8List value) {
    _$storageAtom.reportWrite(value, super.storage, () {
      super.storage = value;
    });
  }

  @override
  String toString() {
    return '''
id: ${id},
name: ${name},
host: ${host},
scheme: ${scheme},
type: ${type},
useDoH: ${useDoH},
onlyHost: ${onlyHost},
directLink: ${directLink},
cookies: ${cookies},
favicon: ${favicon},
username: ${username},
password: ${password},
storage: ${storage}
    ''';
  }
}
