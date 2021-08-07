// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_result_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostResultStore on PostResultStoreBase, Store {
  Computed<List<BooruPost>>? _$postListComputed;

  @override
  List<BooruPost> get postList =>
      (_$postListComputed ??= Computed<List<BooruPost>>(() => super.postList,
              name: 'PostResultStoreBase.postList'))
          .value;

  final _$isLoadingAtom = Atom(name: 'PostResultStoreBase.isLoading');

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

  final _$onDataChangeAsyncAction =
      AsyncAction('PostResultStoreBase.onDataChange');

  @override
  Future<void> onDataChange() {
    return _$onDataChangeAsyncAction.run(() => super.onDataChange());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
postList: ${postList}
    ''';
  }
}
