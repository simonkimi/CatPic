// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PopularResultStore on PopularResultStoreBase, Store {
  Computed<List<BooruPost>>? _$postListComputed;

  @override
  List<BooruPost> get postList =>
      (_$postListComputed ??= Computed<List<BooruPost>>(() => super.postList,
              name: 'PopularResultStoreBase.postList'))
          .value;

  final _$popularTypeAtom = Atom(name: 'PopularResultStoreBase.popularType');

  @override
  PopularType get popularType {
    _$popularTypeAtom.reportRead();
    return super.popularType;
  }

  @override
  set popularType(PopularType value) {
    _$popularTypeAtom.reportWrite(value, super.popularType, () {
      super.popularType = value;
    });
  }

  final _$yearAtom = Atom(name: 'PopularResultStoreBase.year');

  @override
  int get year {
    _$yearAtom.reportRead();
    return super.year;
  }

  @override
  set year(int value) {
    _$yearAtom.reportWrite(value, super.year, () {
      super.year = value;
    });
  }

  final _$monthAtom = Atom(name: 'PopularResultStoreBase.month');

  @override
  int get month {
    _$monthAtom.reportRead();
    return super.month;
  }

  @override
  set month(int value) {
    _$monthAtom.reportWrite(value, super.month, () {
      super.month = value;
    });
  }

  final _$dayAtom = Atom(name: 'PopularResultStoreBase.day');

  @override
  int get day {
    _$dayAtom.reportRead();
    return super.day;
  }

  @override
  set day(int value) {
    _$dayAtom.reportWrite(value, super.day, () {
      super.day = value;
    });
  }

  final _$isLoadingAtom = Atom(name: 'PopularResultStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$setDateAsyncAction = AsyncAction('PopularResultStoreBase.setDate');

  @override
  Future<void> setDate(int yearValue, int monthValue, int dayValue) {
    return _$setDateAsyncAction
        .run(() => super.setDate(yearValue, monthValue, dayValue));
  }

  final _$setTypeAsyncAction = AsyncAction('PopularResultStoreBase.setType');

  @override
  Future<void> setType(PopularType type) {
    return _$setTypeAsyncAction.run(() => super.setType(type));
  }

  final _$onDataChangeAsyncAction =
      AsyncAction('PopularResultStoreBase.onDataChange');

  @override
  Future<void> onDataChange() {
    return _$onDataChangeAsyncAction.run(() => super.onDataChange());
  }

  @override
  String toString() {
    return '''
popularType: ${popularType},
year: ${year},
month: ${month},
day: ${day},
isLoading: ${isLoading},
postList: ${postList}
    ''';
  }
}
