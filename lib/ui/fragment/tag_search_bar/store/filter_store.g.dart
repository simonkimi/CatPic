// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FilterStore on FilterStoreBase, Store {
  final _$searchTextAtom = Atom(name: 'FilterStoreBase.searchText');

  @override
  String get searchText {
    _$searchTextAtom.reportRead();
    return super.searchText;
  }

  @override
  set searchText(String value) {
    _$searchTextAtom.reportWrite(value, super.searchText, () {
      super.searchText = value;
    });
  }

  final _$FilterStoreBaseActionController =
      ActionController(name: 'FilterStoreBase');

  @override
  void setSearchText(String value) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.setSearchText');
    try {
      return super.setSearchText(value);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchText: ${searchText}
    ''';
  }
}
