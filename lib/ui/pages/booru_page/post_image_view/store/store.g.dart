// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostImageViewStore on PostImageViewStoreBase, Store {
  Computed<BooruPost>? _$booruPostComputed;

  @override
  BooruPost get booruPost =>
      (_$booruPostComputed ??= Computed<BooruPost>(() => super.booruPost,
              name: 'PostImageViewStoreBase.booruPost'))
          .value;

  final _$currentIndexAtom = Atom(name: 'PostImageViewStoreBase.currentIndex');

  @override
  int get currentIndex {
    _$currentIndexAtom.reportRead();
    return super.currentIndex;
  }

  @override
  set currentIndex(int value) {
    _$currentIndexAtom.reportWrite(value, super.currentIndex, () {
      super.currentIndex = value;
    });
  }

  final _$infoBarDisplayAtom =
      Atom(name: 'PostImageViewStoreBase.infoBarDisplay');

  @override
  bool get infoBarDisplay {
    _$infoBarDisplayAtom.reportRead();
    return super.infoBarDisplay;
  }

  @override
  set infoBarDisplay(bool value) {
    _$infoBarDisplayAtom.reportWrite(value, super.infoBarDisplay, () {
      super.infoBarDisplay = value;
    });
  }

  final _$pageBarDisplayAtom =
      Atom(name: 'PostImageViewStoreBase.pageBarDisplay');

  @override
  bool get pageBarDisplay {
    _$pageBarDisplayAtom.reportRead();
    return super.pageBarDisplay;
  }

  @override
  set pageBarDisplay(bool value) {
    _$pageBarDisplayAtom.reportWrite(value, super.pageBarDisplay, () {
      super.pageBarDisplay = value;
    });
  }

  final _$setIndexAsyncAction = AsyncAction('PostImageViewStoreBase.setIndex');

  @override
  Future<void> setIndex(int value) {
    return _$setIndexAsyncAction.run(() => super.setIndex(value));
  }

  final _$changeFavouriteStateAsyncAction =
      AsyncAction('PostImageViewStoreBase.changeFavouriteState');

  @override
  Future<bool> changeFavouriteState() {
    return _$changeFavouriteStateAsyncAction
        .run(() => super.changeFavouriteState());
  }

  final _$favouriteAsyncAction =
      AsyncAction('PostImageViewStoreBase.favourite');

  @override
  Future<void> favourite() {
    return _$favouriteAsyncAction.run(() => super.favourite());
  }

  final _$unFavouriteAsyncAction =
      AsyncAction('PostImageViewStoreBase.unFavourite');

  @override
  Future<void> unFavourite() {
    return _$unFavouriteAsyncAction.run(() => super.unFavourite());
  }

  final _$PostImageViewStoreBaseActionController =
      ActionController(name: 'PostImageViewStoreBase');

  @override
  void setInfoBarDisplay(bool value) {
    final _$actionInfo = _$PostImageViewStoreBaseActionController.startAction(
        name: 'PostImageViewStoreBase.setInfoBarDisplay');
    try {
      return super.setInfoBarDisplay(value);
    } finally {
      _$PostImageViewStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInfoBarDisplayWithoutSave(bool value) {
    final _$actionInfo = _$PostImageViewStoreBaseActionController.startAction(
        name: 'PostImageViewStoreBase.setInfoBarDisplayWithoutSave');
    try {
      return super.setInfoBarDisplayWithoutSave(value);
    } finally {
      _$PostImageViewStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPageBarDisplay(bool value) {
    final _$actionInfo = _$PostImageViewStoreBaseActionController.startAction(
        name: 'PostImageViewStoreBase.setPageBarDisplay');
    try {
      return super.setPageBarDisplay(value);
    } finally {
      _$PostImageViewStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentIndex: ${currentIndex},
infoBarDisplay: ${infoBarDisplay},
pageBarDisplay: ${pageBarDisplay},
booruPost: ${booruPost}
    ''';
  }
}
