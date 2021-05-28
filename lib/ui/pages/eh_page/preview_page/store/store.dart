import 'dart:math';
import 'dart:ui' as ui;
import 'package:catpic/data/models/ehentai/gallery_img_model.dart';
import 'package:flutter/material.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/data/models/ehentai/gallery_model.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

class EhGalleryStore = EhGalleryStoreBase with _$EhGalleryStore;

class GalleryPreviewImage {
  GalleryPreviewImage()
      : progress = 0.0.obs,
        loadState = false.obs;
  ui.Image? imageData;
  final RxDouble progress;
  final RxBool loadState;
}

enum LoadingState {
  NONE,
  LOADED,
  FINISH,
  ERROR,
}

class GalleryImage {
  final Rx<LoadingState> state = LoadingState.NONE.obs;
  PreviewImage? previewImage;
  DioImageProvider? imageProvider;
  GalleryImgModel? model;
}

abstract class EhGalleryStoreBase extends ILoadMore<PreviewImage> with Store {
  EhGalleryStoreBase({
    required this.adapter,
    required this.previewModel,
    required this.imageCount,
  })  : previewCacheList = List.filled(imageCount, GalleryImage()),
        super('');

  final EHAdapter adapter;
  final PreViewItemModel previewModel;

  final imageUrlMap = <String, GalleryPreviewImage>{};

  @observable
  String fileSize = '';
  @observable
  String language = '';
  @observable
  int imageCount = 0;
  @observable
  int favouriteCount = 0;

  @observable
  List<CommentModel> commentList = [];

  @observable
  List<TagModels> tagList = [];

  final List<GalleryImage> previewCacheList;

  @override
  @action
  Future<void> onDataChange() async {}

  @override
  Future<void> onRefresh() {
    for (final element in previewCacheList) {
      element.state.value = LoadingState.NONE;
      element.previewImage = null;
    }
    return super.onRefresh();
  }

  @action
  Future<void> loadAll() async {
    await lock.synchronized(() async {
      await Future.wait(
          List.generate((imageCount / 40).ceil(), (ehPage) => ehPage)
              .map((ehPage) {
        if (previewCacheList[ehPage * 40].state.value == LoadingState.NONE) {
          return loadPage(ehPage);
        }
        return Future.value();
      }));
    });
  }

  @override
  @action
  Future<List<PreviewImage>> loadPage(int page) async {
    final ehPage = page - 1;
    if (previewCacheList[ehPage * 40].state.value == LoadingState.LOADED) {
      final cache = List.generate(
          min(
            40,
            imageCount - ehPage * 40,
          ),
          (index) => previewCacheList[index + ehPage * 40].previewImage!);
      return cache;
    }

    try {
      final galleryModel = await adapter.gallery(
        gid: previewModel.gid,
        gtoken: previewModel.gtoken,
        page: ehPage,
        cancelToken: cancelToken,
      );

      for (final waitingImg in galleryModel.previewImages) {
        if (!imageUrlMap.containsKey(waitingImg.image)) {
          final loadingImage = GalleryPreviewImage();
          DioImageProvider(
            url: waitingImg.image,
            dio: adapter.dio,
          ).resolve(const ImageConfiguration()).addListener(
                  ImageStreamListener((ImageInfo image, bool synchronousCall) {
                loadingImage.imageData = image.image;
                loadingImage.loadState.value = true;
              }, onChunk: (ImageChunkEvent event) {
                loadingImage.progress.value = event.cumulativeBytesLoaded /
                    (event.expectedTotalBytes ?? 1);
              }));
          imageUrlMap[waitingImg.image] = loadingImage;
        }
      }
      fileSize = galleryModel.fileSize;
      language = galleryModel.language;
      imageCount = galleryModel.imageCount;
      favouriteCount = galleryModel.favorited;
      commentList = galleryModel.comments;
      tagList = galleryModel.tags;
      galleryModel.previewImages.asMap().forEach((key, value) {
        previewCacheList[ehPage * 40 + key]
          ..state.value = LoadingState.LOADED
          ..previewImage = value
          ..imageProvider = DioImageProvider(
              dio: adapter.dio,
              urlBuilder: () async {
                final imageModel = await adapter.galleryImage(value.target);
                previewCacheList[ehPage * 40 + key]
                  ..state.value = LoadingState.FINISH
                  ..model = imageModel;
                return imageModel.imgUrl;
              });
      });
      return galleryModel.previewImages;
    } catch (e) {
      for (final index in List.generate(
          min(imageCount - ehPage * 40, 40), (index) => index)) {
        previewCacheList[ehPage * 40 + index]
          ..state.value = LoadingState.ERROR
          ..previewImage = null
          ..imageProvider = null
          ..model = null;
      }
      rethrow;
    }
  }

  @override
  int? get pageItemCount => 40;

  void dispose() {
    cancelToken.cancel();
  }
}
