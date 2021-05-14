import 'dart:typed_data';

import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/data/models/ehentai/gallery_model.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:moor/moor.dart';

import '../../../../../main.dart';

part 'store.g.dart';

class EhGalleryStore = EhGalleryStoreBase with _$EhGalleryStore;

class GalleryPreviewImage {
  GalleryPreviewImage()
      : imageData = Uint8List.fromList([]),
        progress = 0.0.obs,
        loadState = false.obs;
  Uint8List imageData;
  final RxDouble progress;
  final RxBool loadState;
}

abstract class EhGalleryStoreBase extends ILoadMore<PreviewImage> with Store {
  EhGalleryStoreBase({
    required this.adapter,
    required this.previewModel,
  }) : super('') {
    onRefresh();
  }

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

  @override
  @action
  Future<void> onDataChange() async {}

  @override
  @action
  Future<List<PreviewImage>> onLoadNextPage() async {
    final galleryModel = await adapter.gallery(
        gid: previewModel.gid, gtoken: previewModel.gtoken, page: page - 1);
    for (final waitingImg in galleryModel.previewImages) {
      if (!imageUrlMap.containsKey(waitingImg.image)) {
        final loadingImage = GalleryPreviewImage();

        adapter.dio.get<List<int>>(waitingImg.image,
            options: settingStore.dioCacheOptions
                .copyWith(
                    policy: CachePolicy.request,
                    keyBuilder: (req) => waitingImg.image)
                .toOptions()
                .copyWith(
                  responseType: ResponseType.bytes,
                ), onReceiveProgress: (current, total) {
          loadingImage.progress.value = current / total;
        }).then((value) {
          loadingImage.loadState.value = true;
          loadingImage.imageData = Uint8List.fromList(value.data!);
        });
        imageUrlMap[waitingImg.image] = loadingImage;
      }
    }
    fileSize = galleryModel.fileSize;
    language = galleryModel.language;
    imageCount = galleryModel.imageCount;
    favouriteCount = galleryModel.favorited;
    commentList = galleryModel.comments;
    tagList = galleryModel.tags;
    return galleryModel.previewImages;
  }

  @override
  int? get pageItemCount => 40;
}
