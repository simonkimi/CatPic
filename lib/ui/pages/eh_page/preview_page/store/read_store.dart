import 'package:catpic/data/models/ehentai/gallery_img_model.dart';
import 'package:catpic/data/models/ehentai/gallery_model.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:synchronized/synchronized.dart';

part 'read_store.g.dart';

class ReadStore = ReadStoreBase with _$ReadStore;

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

abstract class ReadStoreBase with Store {
  ReadStoreBase({
    required this.cachePage,
    required this.currentIndex,
    required this.loadPage,
    required this.imageCount,
    required this.adapter,
  }) : readImageList = List.generate(imageCount, (index) {
          final base = (index / 40).floor();
          if (cachePage.containsKey(base)) {
            return ReadImageModel(
              previewImage: cachePage[base]![index % 40],
              adapter: adapter,
            );
          }
          return ReadImageModel(adapter: adapter);
        }) {
    cachePage.listen((value) {
      value.forEach((base, value) {
        if (readImageList[base * 40].state.value == LoadingState.NONE) {
          value.asMap().forEach((key, value) {
            readImageList[base * 40 + key].loadBase(adapter, value);
          });
        }
      });
    });
  }

  final RxMap<int, List<PreviewImage>> cachePage;
  final Future<List<PreviewImage>> Function(int) loadPage;
  final int imageCount;
  final List<ReadImageModel> readImageList;
  final EHAdapter adapter;

  @observable
  int currentIndex;

  @action
  Future<void> setIndex(int value) async {
    currentIndex = value;
  }
}
