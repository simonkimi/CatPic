// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MainStore on MainStoreBase, Store {
  final _$websiteEntityAtom = Atom(name: 'MainStoreBase.websiteEntity');

  @override
  IWebsiteEntity? get websiteEntity {
    _$websiteEntityAtom.reportRead();
    return super.websiteEntity;
  }

  @override
  set websiteEntity(IWebsiteEntity? value) {
    _$websiteEntityAtom.reportWrite(value, super.websiteEntity, () {
      super.websiteEntity = value;
    });
  }

  final _$searchPageCountAtom = Atom(name: 'MainStoreBase.searchPageCount');

  @override
  int get searchPageCount {
    _$searchPageCountAtom.reportRead();
    return super.searchPageCount;
  }

  @override
  set searchPageCount(int value) {
    _$searchPageCountAtom.reportWrite(value, super.searchPageCount, () {
      super.searchPageCount = value;
    });
  }

  final _$initAsyncAction = AsyncAction('MainStoreBase.init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$updateListAsyncAction = AsyncAction('MainStoreBase.updateList');

  @override
  Future<void> updateList() {
    return _$updateListAsyncAction.run(() => super.updateList());
  }

  final _$setWebsiteAsyncAction = AsyncAction('MainStoreBase.setWebsite');

  @override
  Future<void> setWebsite(dynamic entity) {
    return _$setWebsiteAsyncAction.run(() => super.setWebsite(entity));
  }

  final _$setWebsiteFaviconAsyncAction =
      AsyncAction('MainStoreBase.setWebsiteFavicon');

  @override
  Future<void> setWebsiteFavicon(int entityId, Uint8List favicon) {
    return _$setWebsiteFaviconAsyncAction
        .run(() => super.setWebsiteFavicon(entityId, favicon));
  }

  final _$deleteWebsiteAsyncAction = AsyncAction('MainStoreBase.deleteWebsite');

  @override
  Future<void> deleteWebsite(dynamic entity) {
    return _$deleteWebsiteAsyncAction.run(() => super.deleteWebsite(entity));
  }

  final _$MainStoreBaseActionController =
      ActionController(name: 'MainStoreBase');

  @override
  void addSearchPage() {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.addSearchPage');
    try {
      return super.addSearchPage();
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void descSearchPage() {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.descSearchPage');
    try {
      return super.descSearchPage();
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
websiteEntity: ${websiteEntity},
searchPageCount: ${searchPageCount}
    ''';
  }
}
