// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'website_add_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WebsiteAddStore on WebsiteAddStoreBase, Store {
  final _$currentPageAtom = Atom(name: 'WebsiteAddStoreBase.currentPage');

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  final _$isFavLoadingAtom = Atom(name: 'WebsiteAddStoreBase.isFavLoading');

  @override
  bool get isFavLoading {
    _$isFavLoadingAtom.reportRead();
    return super.isFavLoading;
  }

  @override
  set isFavLoading(bool value) {
    _$isFavLoadingAtom.reportWrite(value, super.isFavLoading, () {
      super.isFavLoading = value;
    });
  }

  final _$isCheckingTypeAtom = Atom(name: 'WebsiteAddStoreBase.isCheckingType');

  @override
  bool get isCheckingType {
    _$isCheckingTypeAtom.reportRead();
    return super.isCheckingType;
  }

  @override
  set isCheckingType(bool value) {
    _$isCheckingTypeAtom.reportWrite(value, super.isCheckingType, () {
      super.isCheckingType = value;
    });
  }

  final _$isFirstCheckTypeAtom =
      Atom(name: 'WebsiteAddStoreBase.isFirstCheckType');

  @override
  bool get isFirstCheckType {
    _$isFirstCheckTypeAtom.reportRead();
    return super.isFirstCheckType;
  }

  @override
  set isFirstCheckType(bool value) {
    _$isFirstCheckTypeAtom.reportWrite(value, super.isFirstCheckType, () {
      super.isFirstCheckType = value;
    });
  }

  final _$websiteNameAtom = Atom(name: 'WebsiteAddStoreBase.websiteName');

  @override
  String get websiteName {
    _$websiteNameAtom.reportRead();
    return super.websiteName;
  }

  @override
  set websiteName(String value) {
    _$websiteNameAtom.reportWrite(value, super.websiteName, () {
      super.websiteName = value;
    });
  }

  final _$websiteHostAtom = Atom(name: 'WebsiteAddStoreBase.websiteHost');

  @override
  String get websiteHost {
    _$websiteHostAtom.reportRead();
    return super.websiteHost;
  }

  @override
  set websiteHost(String value) {
    _$websiteHostAtom.reportWrite(value, super.websiteHost, () {
      super.websiteHost = value;
    });
  }

  final _$schemeAtom = Atom(name: 'WebsiteAddStoreBase.scheme');

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

  final _$websiteTypeAtom = Atom(name: 'WebsiteAddStoreBase.websiteType');

  @override
  int get websiteType {
    _$websiteTypeAtom.reportRead();
    return super.websiteType;
  }

  @override
  set websiteType(int value) {
    _$websiteTypeAtom.reportWrite(value, super.websiteType, () {
      super.websiteType = value;
    });
  }

  final _$useDoHAtom = Atom(name: 'WebsiteAddStoreBase.useDoH');

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

  final _$directLinkAtom = Atom(name: 'WebsiteAddStoreBase.directLink');

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

  final _$onlyHostAtom = Atom(name: 'WebsiteAddStoreBase.onlyHost');

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

  final _$usernameAtom = Atom(name: 'WebsiteAddStoreBase.username');

  @override
  String get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  final _$passwordAtom = Atom(name: 'WebsiteAddStoreBase.password');

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$faviconAtom = Atom(name: 'WebsiteAddStoreBase.favicon');

  @override
  Uint8List? get favicon {
    _$faviconAtom.reportRead();
    return super.favicon;
  }

  @override
  set favicon(Uint8List? value) {
    _$faviconAtom.reportWrite(value, super.favicon, () {
      super.favicon = value;
    });
  }

  final _$requestFaviconAsyncAction =
      AsyncAction('WebsiteAddStoreBase.requestFavicon');

  @override
  Future<void> requestFavicon() {
    return _$requestFaviconAsyncAction.run(() => super.requestFavicon());
  }

  final _$checkWebsiteTypeAsyncAction =
      AsyncAction('WebsiteAddStoreBase.checkWebsiteType');

  @override
  Future<void> checkWebsiteType() {
    return _$checkWebsiteTypeAsyncAction.run(() => super.checkWebsiteType());
  }

  final _$WebsiteAddStoreBaseActionController =
      ActionController(name: 'WebsiteAddStoreBase');

  @override
  void setWebsiteName(String value) {
    final _$actionInfo = _$WebsiteAddStoreBaseActionController.startAction(
        name: 'WebsiteAddStoreBase.setWebsiteName');
    try {
      return super.setWebsiteName(value);
    } finally {
      _$WebsiteAddStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentPage(int page) {
    final _$actionInfo = _$WebsiteAddStoreBaseActionController.startAction(
        name: 'WebsiteAddStoreBase.setCurrentPage');
    try {
      return super.setCurrentPage(page);
    } finally {
      _$WebsiteAddStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWebsiteHost(String value) {
    final _$actionInfo = _$WebsiteAddStoreBaseActionController.startAction(
        name: 'WebsiteAddStoreBase.setWebsiteHost');
    try {
      return super.setWebsiteHost(value);
    } finally {
      _$WebsiteAddStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setScheme(int value) {
    final _$actionInfo = _$WebsiteAddStoreBaseActionController.startAction(
        name: 'WebsiteAddStoreBase.setScheme');
    try {
      return super.setScheme(value);
    } finally {
      _$WebsiteAddStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWebsiteType(int value) {
    final _$actionInfo = _$WebsiteAddStoreBaseActionController.startAction(
        name: 'WebsiteAddStoreBase.setWebsiteType');
    try {
      return super.setWebsiteType(value);
    } finally {
      _$WebsiteAddStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUseDoH(bool value) {
    final _$actionInfo = _$WebsiteAddStoreBaseActionController.startAction(
        name: 'WebsiteAddStoreBase.setUseDoH');
    try {
      return super.setUseDoH(value);
    } finally {
      _$WebsiteAddStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDirectLink(bool value) {
    final _$actionInfo = _$WebsiteAddStoreBaseActionController.startAction(
        name: 'WebsiteAddStoreBase.setDirectLink');
    try {
      return super.setDirectLink(value);
    } finally {
      _$WebsiteAddStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOnlyHost(bool value) {
    final _$actionInfo = _$WebsiteAddStoreBaseActionController.startAction(
        name: 'WebsiteAddStoreBase.setOnlyHost');
    try {
      return super.setOnlyHost(value);
    } finally {
      _$WebsiteAddStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUsername(String value) {
    final _$actionInfo = _$WebsiteAddStoreBaseActionController.startAction(
        name: 'WebsiteAddStoreBase.setUsername');
    try {
      return super.setUsername(value);
    } finally {
      _$WebsiteAddStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$WebsiteAddStoreBaseActionController.startAction(
        name: 'WebsiteAddStoreBase.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$WebsiteAddStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPage: ${currentPage},
isFavLoading: ${isFavLoading},
isCheckingType: ${isCheckingType},
isFirstCheckType: ${isFirstCheckType},
websiteName: ${websiteName},
websiteHost: ${websiteHost},
scheme: ${scheme},
websiteType: ${websiteType},
useDoH: ${useDoH},
directLink: ${directLink},
onlyHost: ${onlyHost},
username: ${username},
password: ${password},
favicon: ${favicon}
    ''';
  }
}
