import 'package:catpic/ui/components/page_slider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:synchronized/synchronized.dart';

part 'store.g.dart';

enum LoadingState { NONE, LOADED, ERROR }

typedef RequestLoadFunc = Future<void> Function(int);
typedef VoidFuture = Future<void> Function();

class EhReadStore = EhReadStoreBase with _$EhReadStore;

abstract class EhReadStoreBase with Store {
  EhReadStoreBase({
    required this.imageCount,
    required this.requestLoad,
    required this.currentIndex,
  }) : readImageList = List.generate(
            imageCount,
            (index) => ReadImgModel(
                  index: index,
                  requestLoad: () async {
                    requestLoad(index);
                  },
                ));

  final int imageCount;
  final List<ReadImgModel> readImageList;
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

class ReadImgModel {
  ReadImgModel({
    required this.index,
    required this.requestLoad,
  });

  final VoidFuture requestLoad;
  final Rx<LoadingState> state = LoadingState.NONE.obs;
  final int index;
  ImageProvider? imageProvider;

  final Lock lock = Lock();
}
