// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EhReadStore on EhReadStoreBase, Store {
  final _$canMovePageAtom = Atom(name: 'EhReadStoreBase.canMovePage');

  @override
  bool get canMovePage {
    _$canMovePageAtom.reportRead();
    return super.canMovePage;
  }

  @override
  set canMovePage(bool value) {
    _$canMovePageAtom.reportWrite(value, super.canMovePage, () {
      super.canMovePage = value;
    });
  }

  final _$displayPageSliderAtom =
      Atom(name: 'EhReadStoreBase.displayPageSlider');

  @override
  bool get displayPageSlider {
    _$displayPageSliderAtom.reportRead();
    return super.displayPageSlider;
  }

  @override
  set displayPageSlider(bool value) {
    _$displayPageSliderAtom.reportWrite(value, super.displayPageSlider, () {
      super.displayPageSlider = value;
    });
  }

  final _$EhReadStoreBaseActionController =
      ActionController(name: 'EhReadStoreBase');

  @override
  void setPageSliderDisplay(bool value) {
    final _$actionInfo = _$EhReadStoreBaseActionController.startAction(
        name: 'EhReadStoreBase.setPageSliderDisplay');
    try {
      return super.setPageSliderDisplay(value);
    } finally {
      _$EhReadStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
canMovePage: ${canMovePage},
displayPageSlider: ${displayPageSlider}
    ''';
  }
}
