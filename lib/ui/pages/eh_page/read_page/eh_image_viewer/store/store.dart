import 'package:catpic/ui/components/page_slider.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:synchronized/synchronized.dart';

part 'store.g.dart';

enum LoadingState { NONE, LOADED, ERROR }

typedef RequestLoadFunc = Future<void> Function(int index, bool isAuto);
typedef LoadFuture<T> = Future<void> Function(T isAuto);

class EhReadStore<T> = EhReadStoreBase<T> with _$EhReadStore;

abstract class EhReadStoreBase<T> with Store {
  EhReadStoreBase({
    required this.imageCount,
    required this.requestLoad,
    required this.currentIndex,
  }) : readImageList = List.generate(
            imageCount,
            (index) => ReadImgModel(
                  index: index,
                  loadFunc: (bool isAuto) async {
                    requestLoad(index, isAuto);
                  },
                ));

  final int imageCount;
  final List<ReadImgModel<T>> readImageList;
  final RequestLoadFunc requestLoad;

  @observable
  int currentIndex;

  @observable
  var displayPageSlider = false;

  final pageSliderController = PageSliderController();

  var lastIdleTime = DateTime.now();

  var isIdle = true;

  @action
  void setPageSliderDisplay(bool value) {
    displayPageSlider = value;
  }

  @action
  Future<void> setIndex(int value) async {
    pageSliderController.setValue(value);
    currentIndex = value;
    // TODO: 更换历史记录位置
    // await DB().ehReadHistoryDao.setPage(gid, gtoken, value);
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
}
