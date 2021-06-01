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
import 'package:synchronized/synchronized.dart';

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

abstract class EhGalleryStoreBase extends ILoadMore<PreviewImage> with Store {
  EhGalleryStoreBase({
    required this.imageCount,
    required this.adapter,
    required this.previewModel,
  })  : pageLoadLock = List.filled(imageCount, Lock()),
        super('') {
    init();
  }

  final int imageCount;
  final EHAdapter adapter;
  final PreViewItemModel previewModel;

  final imageUrlMap = <String, GalleryPreviewImage>{};
  final pageCache = <int, List<PreviewImage>>{}.obs;
  late final List<ReadImageModel> readImageList;
  final List<Lock> pageLoadLock;

  @observable
  String fileSize = '';
  @observable
  String language = '';
  @observable
  int favouriteCount = 0;
  @observable
  List<CommentModel> commentList = [];
  @observable
  List<TagModels> tagList = [];

  @override
  int? get pageItemCount => 40;

  void init() {
    readImageList = List.generate(imageCount, (index) {
      final base = (index / 40).floor();
      if (pageCache.containsKey(base)) {
        return ReadImageModel(
          previewImage: pageCache[base]![index % 40],
          adapter: adapter,
        );
      }
      return ReadImageModel(adapter: adapter);
    });
    pageCache.listen((value) {
      value.forEach((base, value) {
        if (readImageList[base * 40].state.value == LoadingState.NONE) {
          value.asMap().forEach((key, value) {
            readImageList[base * 40 + key].loadBase(adapter, value);
          });
        }
      });
    });
  }

  @override
  Future<void> onRefresh() {
    pageCache.clear();
    return super.onRefresh();
  }

  @override
  @action
  Future<List<PreviewImage>> loadPage(int page,
      [bool loadPreview = true]) async {
    final ehPage = page - 1;
    print('load Page $ehPage');
    return await pageLoadLock[ehPage].synchronized(() async {
      final useCache = pageCache.containsKey(ehPage);
      late final List<PreviewImage> imageList;

      if (useCache) {
        imageList = pageCache[ehPage]!;
      } else {
        final galleryModel = await adapter.gallery(
          gid: previewModel.gid,
          gtoken: previewModel.gtoken,
          page: ehPage,
        );
        fileSize = galleryModel.fileSize;
        language = galleryModel.language;
        favouriteCount = galleryModel.favorited;
        commentList = galleryModel.comments;
        tagList = galleryModel.tags;
        pageCache[ehPage] = galleryModel.previewImages;
        imageList = galleryModel.previewImages;
      }
      if (loadPreview) {
        for (final waitingImg in imageList) {
          if (!imageUrlMap.containsKey(waitingImg.image)) {
            final loadingImage = GalleryPreviewImage();
            // 加载预览图
            DioImageProvider(
              url: waitingImg.image,
              dio: adapter.dio,
            ).resolve(const ImageConfiguration()).addListener(
                    ImageStreamListener(
                        (ImageInfo image, bool synchronousCall) {
                  loadingImage.imageData = image.image;
                  loadingImage.loadState.value = true;
                }, onChunk: (ImageChunkEvent event) {
                  loadingImage.progress.value = event.cumulativeBytesLoaded /
                      (event.expectedTotalBytes ?? 1);
                }));
            imageUrlMap[waitingImg.image] = loadingImage;
          }
        }
      }
      print('load Page $ehPage finish');
      return imageList;
    });
  }

  @override
  @action
  Future<void> onDataChange() async {}

  void dispose() {
    cancelToken.cancel();
  }
}

enum LoadingState { NONE, LOADED, ERROR }

class ReadImageModel {
  ReadImageModel({
    required this.adapter,
    this.previewImage,
  }) : state = previewImage != null
            ? LoadingState.LOADED.obs
            : LoadingState.NONE.obs {
    if (previewImage != null) {
      loadBase(adapter, previewImage!);
    }
  }

  final Rx<LoadingState> state;
  PreviewImage? previewImage;
  GalleryImgModel? model;
  final EHAdapter adapter;

  DioImageProvider? imageProvider;

  final Lock lock = Lock();

  Future<GalleryImgModel> loadModel(EHAdapter adapter) async {
    return await lock.synchronized(() async {
      if (this.model != null) {
        return this.model!;
      }
      final model = await adapter.galleryImage(previewImage!.target);
      this.model = model;
      return model;
    });
  }

  Future<void> loadBase(EHAdapter adapter, PreviewImage value) async {
    imageProvider = DioImageProvider(
        dio: adapter.dio,
        urlBuilder: () async {
          return (await loadModel(adapter)).imgUrl;
        });
    state.value = LoadingState.LOADED;
    previewImage = value;
  }
}
