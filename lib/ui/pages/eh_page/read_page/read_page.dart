import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/page_slider.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/eh_image_viewer.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class BackAppBar extends HookWidget implements PreferredSizeWidget {
  const BackAppBar({
    Key? key,
    required this.store,
  }) : super(key: key);

  final EhReadStore store;

  @override
  Widget build(BuildContext context) {
    final appBarController =
        useAnimationController(duration: const Duration(milliseconds: 200));

    final appBarHideAni =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -1))
            .animate(appBarController);

    return Observer(builder: (context) {
      appBarController.byValue(store.displayPageSlider);
      return SlideTransition(
        position: appBarHideAni,
        child: AppBar(
          backgroundColor: Colors.transparent,
          leading: appBarBackButton(),
          elevation: 0,
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class EhReadPage extends HookWidget {
  EhReadPage({
    Key? key,
    required this.store,
    required this.startIndex,
  }) : super(key: key);

  final EhReadStore store;
  final int startIndex;

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(store: store),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: buildImg(),
      bottomNavigationBar: buildBottomBar(),
      extendBody: true,
    );
  }

  Widget buildImg() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: EhImageViewer(
        store: store,
        startIndex: startIndex,
        pageController: pageController,
        onCenterTap: () {
          store.setPageSliderDisplay(!store.displayPageSlider);
        },
        onIndexChange: (value) {
          store.setIndex(value);
        },
      ),
    );
  }

  Widget buildBottomBar() {
    final pageSliderController =
        useAnimationController(duration: const Duration(milliseconds: 200));

    final pageSliderHideAni =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 2))
            .animate(pageSliderController);

    return Observer(builder: (_) {
      pageSliderController.byValue(store.displayPageSlider);
      return SlideTransition(
        position: pageSliderHideAni,
        child: BottomAppBar(
          color: Colors.transparent,
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              child: Observer(builder: (_) {
                return PageSlider(
                  value: store.currentIndex + 1,
                  count: store.imageCount,
                  controller: store.pageSliderController,
                  onChange: (int value) {
                    store.setIndex(value - 1);
                    pageController.jumpToPage(value - 1);
                  },
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}
