// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eh_website.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EhWebsiteEntity on EhWebsiteEntityBase, Store {
  Computed<DisplayType>? _$displayTypeComputed;

  @override
  DisplayType get displayType =>
      (_$displayTypeComputed ??= Computed<DisplayType>(() => super.displayType,
              name: 'EhWebsiteEntityBase.displayType'))
          .value;
  Computed<ScreenAxis>? _$screenAxisComputed;

  @override
  ScreenAxis get screenAxis =>
      (_$screenAxisComputed ??= Computed<ScreenAxis>(() => super.screenAxis,
              name: 'EhWebsiteEntityBase.screenAxis'))
          .value;
  Computed<ReadAxis>? _$readAxisComputed;

  @override
  ReadAxis get readAxis =>
      (_$readAxisComputed ??= Computed<ReadAxis>(() => super.readAxis,
              name: 'EhWebsiteEntityBase.readAxis'))
          .value;

  final _$_readAxisAtom = Atom(name: 'EhWebsiteEntityBase._readAxis');

  @override
  ReadAxis get _readAxis {
    _$_readAxisAtom.reportRead();
    return super._readAxis;
  }

  @override
  set _readAxis(ReadAxis value) {
    _$_readAxisAtom.reportWrite(value, super._readAxis, () {
      super._readAxis = value;
    });
  }

  final _$_screenAxisAtom = Atom(name: 'EhWebsiteEntityBase._screenAxis');

  @override
  ScreenAxis get _screenAxis {
    _$_screenAxisAtom.reportRead();
    return super._screenAxis;
  }

  @override
  set _screenAxis(ScreenAxis value) {
    _$_screenAxisAtom.reportWrite(value, super._screenAxis, () {
      super._screenAxis = value;
    });
  }

  final _$_displayTypeAtom = Atom(name: 'EhWebsiteEntityBase._displayType');

  @override
  DisplayType get _displayType {
    _$_displayTypeAtom.reportRead();
    return super._displayType;
  }

  @override
  set _displayType(DisplayType value) {
    _$_displayTypeAtom.reportWrite(value, super._displayType, () {
      super._displayType = value;
    });
  }

  final _$nameAtom = Atom(name: 'EhWebsiteEntityBase.name');

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

  final _$hostAtom = Atom(name: 'EhWebsiteEntityBase.host');

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

  final _$schemeAtom = Atom(name: 'EhWebsiteEntityBase.scheme');

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

  final _$typeAtom = Atom(name: 'EhWebsiteEntityBase.type');

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

  final _$useDoHAtom = Atom(name: 'EhWebsiteEntityBase.useDoH');

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

  final _$onlyHostAtom = Atom(name: 'EhWebsiteEntityBase.onlyHost');

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

  final _$directLinkAtom = Atom(name: 'EhWebsiteEntityBase.directLink');

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

  final _$cookiesAtom = Atom(name: 'EhWebsiteEntityBase.cookies');

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

  final _$faviconAtom = Atom(name: 'EhWebsiteEntityBase.favicon');

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

  final _$usernameAtom = Atom(name: 'EhWebsiteEntityBase.username');

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

  final _$passwordAtom = Atom(name: 'EhWebsiteEntityBase.password');

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

  final _$storageAtom = Atom(name: 'EhWebsiteEntityBase.storage');

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
storage: ${storage},
displayType: ${displayType},
screenAxis: ${screenAxis},
readAxis: ${readAxis}
    ''';
  }
}
