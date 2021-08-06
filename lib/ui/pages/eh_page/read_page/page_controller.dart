import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'eh_image_viewer/store/store.dart';

class EhPageController {
  EhPageController({
    required this.store,
    int startIndex = 0,
  })  : index = startIndex,
        pageController = PageController(initialPage: startIndex),
        _indexStream = StreamController<int>.broadcast() {
    pageController.addListener(pageListener);
    listPositionsListener.itemPositions.addListener(listListener);
    _indexStream.add(startIndex);
  }

  var index = 0;
  final EhReadStore store;
  final PageController pageController;
  final StreamController<int> _indexStream;
  final listController = ItemScrollController();
  final listPositionsListener = ItemPositionsListener.create();

  void pageListener() {
    if (pageController.hasClients) {
      index = pageController.page?.round() ?? 0;
      _indexStream.add(index);
    }
  }

  void listListener() {
    if (listController.isAttached) {
      index = listPositionsListener.itemPositions.value.first.index;
      _indexStream.add(index);
    }
  }

  void jumpTo(int index) {
    if (pageController.hasClients) {
      pageController.jumpToPage(index);
    }
    if (listController.isAttached) {
      listController.scrollTo(index: index, duration: 200.milliseconds);
    }
  }

  void dispose() {
    pageController.removeListener(pageListener);
    listPositionsListener.itemPositions.removeListener(listListener);
    _indexStream.close();
  }

  Stream<int> get indexStream => _indexStream.stream;
}
