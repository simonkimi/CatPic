import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:synchronized/synchronized.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:catpic/data/models/gen/eh_gallery_img.pb.dart';

part 'store.g.dart';

enum LoadingState { NONE, LOADED, ERROR }

typedef RequestLoadFunc = Future<void> Function(int index, bool isAuto);
typedef LoadFuture<T> = Future<void> Function(T isAuto);

class EhReadStore = EhReadStoreBase with _$EhReadStore;

abstract class EhReadStoreBase with Store {
  EhReadStoreBase({
    required this.imageCount,
    required this.requestLoad,
    required this.gid,
    required this.gtoken,
    required this.adapter,
  })  : readImageList = List.generate(
            imageCount,
            (index) => ReadImgModel(
                  index: index,
                  loadFunc: (bool isAuto) async {
                    requestLoad(index, isAuto);
                  },
                )),
        previewImageList = List.generate(
            imageCount,
            (index) => ReadImgModel(
                  index: index,
                  loadFunc: (bool isAuto) async {
                    requestLoad(index, isAuto);
                  },
                ));

  final String gid;
  final String gtoken;
  final int imageCount;
  final List<ReadImgModel<GalleryImgModel>> readImageList;
  final List<ReadImgModel<GalleryPreviewImageModel>> previewImageList;
  final RequestLoadFunc requestLoad;
  final EHAdapter adapter;

  @observable
  bool canMovePage = true;

  @observable
  var displayPageSlider = false;

  var lastIdleTime = DateTime.now();

  var isIdle = true;

  @action
  void setPageSliderDisplay(bool value) {
    displayPageSlider = value;
  }
}

class ReadImgModel<T> {
  ReadImgModel({
    required this.index,
    required this.loadFunc,
  });

  final LoadFuture<bool> loadFunc;
  final Rx<LoadingState> state = LoadingState.NONE.obs;
  final int index;

  T? extra;
  Object? lastException;
  DioImageProvider? imageProvider;

  final Lock lock = Lock();

  Future<void> requestLoad(bool isAuto) async {
    loadFunc(isAuto).catchError((err) {
      lastException = err;
      imageProvider = null;
      extra = null;
      state.value = LoadingState.ERROR;
    });
  }

  void dispose() {
    imageProvider?.dispose();
  }

  void reset() {
    imageProvider = null;
    state.value = LoadingState.NONE;
    lastException = null;
    extra = null;
  }
}
