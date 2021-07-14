import 'dart:ui' as ui;

import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/data/models/gen/eh_gallery_img.pb.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:catpic/data/models/gen/eh_preview.pb.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:synchronized/synchronized.dart';
import 'package:catpic/utils/utils.dart';

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
    required this.adapter,
    this.previewModel,
    this.galleryBase,
  })  : gid = previewModel?.gid ?? galleryBase!.gid,
        gtoken = previewModel?.gtoken ?? galleryBase!.token,
        isBasicLoaded = previewModel != null,
        uploadTime = previewModel?.uploadTime ?? '',
        uploader = previewModel?.uploader ?? '',
        tag = previewModel?.tag ?? EhGalleryType.Misc,
        star = previewModel?.stars ?? 0.0,
        title = previewModel?.title ?? '',
        imageCount = previewModel?.pages ?? 0,
        previewImageUrl = previewModel?.previewImg ?? '',
        pageLoadLock = previewModel == null
            ? [Lock()]
            : List.filled((previewModel.pages / 40).ceil(), Lock()),
        super('') {
    init();
  }

  int imageCount;

  final EHAdapter adapter;
  final PreViewItemModel? previewModel;
  final GalleryBase? galleryBase;

  final String gid;
  final String gtoken;

  final imageUrlMap = <String, GalleryPreviewImage>{};
  final pageCache = <int, List<PreviewImage>>{}.obs;
  late final List<ReadImageModel> readImageList;
  final List<Lock> pageLoadLock;

  final updateList = ObservableList<GalleryUpdate>();

  @override
  @observable
  bool isLoading = false;

  @override
  @observable
  String? lastException;

  @observable
  String fileSize = '';

  @observable
  String language = '';

  @observable
  int favouriteCount = 0;

  @observable
  List<CommentModel> commentList = [];

  @observable
  String title = '';

  @observable
  String uploader = '';

  @observable
  double star = 0.0;

  @observable
  int starMember = 0;

  @observable
  String previewImageUrl = '';

  @observable
  int tag = EhGalleryType.Misc;

  @observable
  String uploadTime = '';

  @observable
  bool isBasicLoaded = false;

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
    return await (pageLoadLock[ehPage]).synchronized(() async {
      final useCache = pageCache.containsKey(ehPage);
      late final List<PreviewImage> imageList;
      if (useCache) {
        imageList = pageCache[ehPage]!;
      } else {
        final galleryModel = await adapter.gallery(
          gid: previewModel?.gid ?? galleryBase!.gid,
          gtoken: previewModel?.gtoken ?? galleryBase!.token,
          page: ehPage,
        );
        imageCount = galleryModel.imageCount;
        if (!isBasicLoaded && pageLoadLock.length == 1) {
          pageLoadLock
              .addAll(List.filled((imageCount / 40).ceil() - 1, Lock()));
        }
        fileSize = galleryModel.fileSize;
        language = galleryModel.language;
        favouriteCount = galleryModel.favorited;
        commentList = galleryModel.comments;
        tagList = galleryModel.tags;
        pageCache[ehPage] = galleryModel.previewImages;
        imageList = galleryModel.previewImages;
        title = galleryModel.title;
        previewImageUrl = galleryModel.previewImage;
        star = galleryModel.star;
        starMember = galleryModel.starMember;
        tag = galleryModel.tag;
        uploader = galleryModel.uploader;
        uploadTime = galleryModel.uploadTime;
        isBasicLoaded = true;
        if (updateList.isEmpty && galleryModel.updates.isNotEmpty)
          updateList.addAll(galleryModel.updates);
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

  @override
  bool isItemExist(PreviewImage item) => false;

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

  // loadBase加载model的网络部分
  Future<GalleryImgModel> loadModel(EHAdapter adapter, String target) async {
    return await lock.synchronized(() async {
      if (this.model != null) {
        return this.model!;
      }
      final reg = RegExp(r's/(.+?)/(\d+)-(\d+)');
      final match = reg.firstMatch(target)!;
      final token = match[1]!;
      final gid = match[2]!;
      final page = match[3]!.toInt();
      final model = await adapter.galleryImage(
        gtoken: token,
        gid: gid,
        page: page,
      );
      this.model = model;
      return model;
    });
  }

  // 加载page的ImageProvider和基础数据
  Future<void> loadBase(EHAdapter adapter, PreviewImage value) async {
    previewImage = value;
    imageProvider = DioImageProvider(
        dio: adapter.dio,
        builder: () async {
          final model = await loadModel(adapter, value.target);
          return DioImageParams(url: model.imgUrl, cacheKey: model.sha);
        });
    state.value = LoadingState.LOADED;
  }
}
