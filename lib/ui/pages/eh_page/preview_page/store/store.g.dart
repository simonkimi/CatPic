// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EhGalleryStore on EhGalleryStoreBase, Store {
  Computed<bool>? _$isLoadedComputed;

  @override
  bool get isLoaded =>
      (_$isLoadedComputed ??= Computed<bool>(() => super.isLoaded,
              name: 'EhGalleryStoreBase.isLoaded'))
          .value;

  final _$previewModelAtom = Atom(name: 'EhGalleryStoreBase.previewModel');

  @override
  PreViewItemModel? get previewModel {
    _$previewModelAtom.reportRead();
    return super.previewModel;
  }

  @override
  set previewModel(PreViewItemModel? value) {
    _$previewModelAtom.reportWrite(value, super.previewModel, () {
      super.previewModel = value;
    });
  }

  final _$galleryModelAtom = Atom(name: 'EhGalleryStoreBase.galleryModel');

  @override
  GalleryModel? get galleryModel {
    _$galleryModelAtom.reportRead();
    return super.galleryModel;
  }

  @override
  set galleryModel(GalleryModel? value) {
    _$galleryModelAtom.reportWrite(value, super.galleryModel, () {
      super.galleryModel = value;
    });
  }

  final _$previewAspectRatioAtom =
      Atom(name: 'EhGalleryStoreBase.previewAspectRatio');

  @override
  double? get previewAspectRatio {
    _$previewAspectRatioAtom.reportRead();
    return super.previewAspectRatio;
  }

  @override
  set previewAspectRatio(double? value) {
    _$previewAspectRatioAtom.reportWrite(value, super.previewAspectRatio, () {
      super.previewAspectRatio = value;
    });
  }

  final _$favcatAtom = Atom(name: 'EhGalleryStoreBase.favcat');

  @override
  int get favcat {
    _$favcatAtom.reportRead();
    return super.favcat;
  }

  @override
  set favcat(int value) {
    _$favcatAtom.reportWrite(value, super.favcat, () {
      super.favcat = value;
    });
  }

  final _$isFavLoadingAtom = Atom(name: 'EhGalleryStoreBase.isFavLoading');

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

  final _$isDownloadLoadingAtom =
      Atom(name: 'EhGalleryStoreBase.isDownloadLoading');

  @override
  bool get isDownloadLoading {
    _$isDownloadLoadingAtom.reportRead();
    return super.isDownloadLoading;
  }

  @override
  set isDownloadLoading(bool value) {
    _$isDownloadLoadingAtom.reportWrite(value, super.isDownloadLoading, () {
      super.isDownloadLoading = value;
    });
  }

  final _$isLoadingAtom = Atom(name: 'EhGalleryStoreBase.isLoading');

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

  final _$lastExceptionAtom = Atom(name: 'EhGalleryStoreBase.lastException');

  @override
  String? get lastException {
    _$lastExceptionAtom.reportRead();
    return super.lastException;
  }

  @override
  set lastException(String? value) {
    _$lastExceptionAtom.reportWrite(value, super.lastException, () {
      super.lastException = value;
    });
  }

  final _$loadBaseModelAsyncAction =
      AsyncAction('EhGalleryStoreBase.loadBaseModel');

  @override
  Future<GalleryModel> loadBaseModel() {
    return _$loadBaseModelAsyncAction.run(() => super.loadBaseModel());
  }

  final _$onFavouriteClickAsyncAction =
      AsyncAction('EhGalleryStoreBase.onFavouriteClick');

  @override
  Future<bool> onFavouriteClick(int favcat) {
    return _$onFavouriteClickAsyncAction
        .run(() => super.onFavouriteClick(favcat));
  }

  final _$onDownloadClickAsyncAction =
      AsyncAction('EhGalleryStoreBase.onDownloadClick');

  @override
  Future<bool> onDownloadClick() {
    return _$onDownloadClickAsyncAction.run(() => super.onDownloadClick());
  }

  final _$onDataChangeAsyncAction =
      AsyncAction('EhGalleryStoreBase.onDataChange');

  @override
  Future<void> onDataChange() {
    return _$onDataChangeAsyncAction.run(() => super.onDataChange());
  }

  @override
  String toString() {
    return '''
previewModel: ${previewModel},
galleryModel: ${galleryModel},
previewAspectRatio: ${previewAspectRatio},
favcat: ${favcat},
isFavLoading: ${isFavLoading},
isDownloadLoading: ${isDownloadLoading},
isLoading: ${isLoading},
lastException: ${lastException},
isLoaded: ${isLoaded}
    ''';
  }
}
