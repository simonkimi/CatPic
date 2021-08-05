import 'dart:math';

import 'package:catpic/data/database/database.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/eh_image_viewer.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/store/store.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';

enum PageViewerState {
  Single,
  DoubleNormal,
  DoubleCover,
}

class BackAppBar extends HookWidget implements PreferredSizeWidget {
  const BackAppBar({
    Key? key,
    required this.store,
    required this.onPageViewerStateChange,
  }) : super(key: key);

  final EhReadStore store;
  final ValueChanged<PageViewerState> onPageViewerStateChange;

  @override
  Widget build(BuildContext context) {
    final appBarController =
        useAnimationController(duration: const Duration(milliseconds: 200));

    final appBarHideAni =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -1))
            .animate(appBarController);

    final pageState = useState(PageViewerState.Single);

    return Observer(builder: (context) {
      appBarController.byValue(store.displayPageSlider);
      return SlideTransition(
        position: appBarHideAni,
        child: AppBar(
          backgroundColor: Colors.transparent,
          leading: appBarBackButton(),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  switch (pageState.value) {
                    case PageViewerState.Single:
                      pageState.value = PageViewerState.DoubleNormal;
                      break;
                    case PageViewerState.DoubleNormal:
                      pageState.value = PageViewerState.DoubleCover;
                      break;
                    case PageViewerState.DoubleCover:
                      pageState.value = PageViewerState.Single;
                      break;
                  }
                  onPageViewerStateChange(pageState.value);
                },
                icon: pageState.value == PageViewerState.Single
                    ? const Icon(Icons.library_books_sharp)
                    : pageState.value == PageViewerState.DoubleNormal
                        ? const Icon(Icons.chrome_reader_mode_outlined)
                        : const Icon(Icons.chrome_reader_mode)),
          ],
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class EhReadPage extends StatefulWidget {
  const EhReadPage({
    Key? key,
    required this.store,
    required this.startIndex,
  }) : super(key: key);

  final EhReadStore store;
  final int startIndex;

  @override
  _EhReadPageState createState() => _EhReadPageState();
}

class _EhReadPageState extends State<EhReadPage> with TickerProviderStateMixin {
  late final AnimationController pageSliderController;
  late final Animation<Offset> pageSliderHideAni;
  final pageController = PageController();

  var pageViewerState = PageViewerState.Single;

  @override
  void initState() {
    super.initState();
    pageSliderController =
        AnimationController(vsync: this, duration: 200.milliseconds);
    pageSliderHideAni =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 2))
            .animate(pageSliderController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        store: widget.store,
        onPageViewerStateChange: (value) {
          setState(() {
            pageViewerState = value;
          });
          switch (value) {
            case PageViewerState.Single: // 从DoubleCover而来
              Future.delayed(10.milliseconds, () {
                pageController
                    .jumpToPage((pageController.page?.toInt() ?? 0) * 2 - 1);
              });
              break;
            case PageViewerState.DoubleNormal: // 从Single而来
              Future.delayed(10.milliseconds, () {
                pageController
                    .jumpToPage(((pageController.page ?? 0) / 2).floor());
              });
              break;
            case PageViewerState.DoubleCover: // 从DoubleNormal而来
              Future.delayed(10.milliseconds, () {
                pageController
                    .jumpToPage((pageController.page?.toInt() ?? 0) + 1);
              });
          }
        },
      ),
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
        store: widget.store,
        startIndex: widget.startIndex,
        pageController: pageController,
        pageViewerState: pageViewerState,
        onCenterTap: () {
          widget.store.setPageSliderDisplay(!widget.store.displayPageSlider);
        },
        onIndexChange: (value) {
          widget.store.setIndex(value);
          DB()
              .ehReadHistoryDao
              .setPage(widget.store.gid, widget.store.gtoken, value);
        },
      ),
    );
  }

  Widget buildBottomBar() {
    return Observer(builder: (_) {
      pageSliderController.byValue(widget.store.displayPageSlider);
      return SlideTransition(
        position: pageSliderHideAni,
        child: Container(
          color: Colors.black54,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                child: ImageSlider(
                  count: widget.store.imageCount,
                  controller: pageController,
                  store: widget.store,
                  pageViewerState: pageViewerState,
                ),
              ),
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  child: PageSlider(
                    count: widget.store.imageCount,
                    controller: pageController,
                    pageViewerState: pageViewerState,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ImageSlider extends StatefulWidget {
  const ImageSlider({
    Key? key,
    required this.count,
    required this.controller,
    required this.store,
    required this.pageViewerState,
  }) : super(key: key);

  final int count;
  final PageController controller;
  final EhReadStore store;
  final PageViewerState pageViewerState;

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final listGlobalKey = GlobalKey();
  final scrollController = ScrollController();

  var _currentValue = 0;

  void _listener() {
    final controllerPage = widget.controller.page?.round() ?? 0;
    late final int page;
    switch (widget.pageViewerState) {
      case PageViewerState.Single:
        page = controllerPage;
        break;
      case PageViewerState.DoubleNormal:
        page = controllerPage * 2;
        break;
      case PageViewerState.DoubleCover:
        page = (controllerPage - 1) * 2 + 1;
        break;
    }
    if (page != _currentValue) {
      jumpToOffset(page);
      setState(() {
        _currentValue = page;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void jumpToOffset(int index) {
    final box = listGlobalKey.currentContext?.findRenderObject() as RenderBox?;
    final boxSize = box?.size;
    if (boxSize != null) {
      final offset = index * (boxSize.height * 0.618 + 2);

      final currentOffset = scrollController.offset;

      if ((offset - currentOffset).abs() > boxSize.width * 1.5) {
        scrollController.jumpTo(offset);
      } else {
        scrollController.animateTo(offset,
            duration: 300.milliseconds, curve: Curves.ease);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: listGlobalKey,
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      cacheExtent: 1000,
      children: List.generate(widget.count, (index) {
        return InkWell(
          onTap: () {
            late final int page;
            switch (widget.pageViewerState) {
              case PageViewerState.Single:
                page = index;
                break;
              case PageViewerState.DoubleNormal:
                page = (index / 2).ceil();
                break;
              case PageViewerState.DoubleCover:
                page = ((index + 1) / 2).floor();
                break;
            }
            widget.controller.jumpToPage(page);
          },
          child: Obx(() {
            final model = widget.store.previewImageList[index];
            if (model.state.value == LoadingState.NONE) {
              model.requestLoad(true);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: AspectRatio(
                  aspectRatio: 0.618,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.1, color: Colors.white),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            if (model.state.value == LoadingState.ERROR) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: AspectRatio(
                  aspectRatio: 0.618,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.1, color: Colors.white),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.error,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              );
            }
            final extra = model.extra!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: AspectRatio(
                aspectRatio: 0.618,
                child: Center(
                  child: extra.isLarge
                      ? ExtendedImage(
                          image: model.imageProvider!,
                          enableLoadState: true,
                          loadStateChanged: (state) {
                            if (state.extendedImageLoadState ==
                                LoadState.loading) {
                              return const Center(
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      : ExtendedImage(
                          image: ExtendedResizeImage(model.imageProvider!,
                              maxBytes: 50),
                          enableLoadState: true,
                          loadStateChanged: (state) {
                            if (state.extendedImageLoadState ==
                                LoadState.loading) {
                              return const Center(
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                ),
                              );
                            }
                            if (state.extendedImageLoadState ==
                                LoadState.completed) {
                              return AspectRatio(
                                aspectRatio: extra.width / extra.height,
                                child: ExtendedRawImage(
                                  image: state.extendedImageInfo?.image,
                                  width: extra.width + .0,
                                  height: extra.height + .0,
                                  fit: BoxFit.fill,
                                  sourceRect: Rect.fromLTWH(
                                    extra.positioning + .0,
                                    0,
                                    100,
                                    extra.height + .0,
                                  ),
                                  scale: 0.5,
                                ),
                              );
                            }
                          },
                        ),
                ),
              ),
            );
          }),
        );
      }).toList(),
    );
  }
}

class PageSlider extends StatefulWidget {
  const PageSlider({
    Key? key,
    required this.count,
    required this.controller,
    required this.pageViewerState,
  }) : super(key: key);

  final int count;
  final PageController controller;
  final PageViewerState pageViewerState;

  @override
  _PageSliderState createState() => _PageSliderState();
}

class _PageSliderState extends State<PageSlider> {
  var _currentValue = 0;

  void listener() {
    final controllerPage = widget.controller.page?.round() ?? 0;
    late final int page;
    switch (widget.pageViewerState) {
      case PageViewerState.Single:
        page = controllerPage;
        break;
      case PageViewerState.DoubleNormal:
        page = controllerPage * 2;
        break;
      case PageViewerState.DoubleCover:
        page = max((controllerPage - 1) * 2 + 1, 0);
        break;
    }
    print('$controllerPage ${widget.pageViewerState} $page');
    if (page != _currentValue) {
      setState(() {
        _currentValue = page;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            (_currentValue + 1).toString(),
            style: const TextStyle(color: Colors.white),
          ),
          Expanded(
            child: Slider(
              onChangeEnd: (value) {
                late final int page;
                switch (widget.pageViewerState) {
                  case PageViewerState.Single:
                    page = value.floor();
                    break;
                  case PageViewerState.DoubleNormal:
                    page = (value.floor() / 2).ceil();
                    break;
                  case PageViewerState.DoubleCover:
                    page = ((value.floor() + 1) / 2).floor();
                    break;
                }
                setState(() {
                  _currentValue = value.floor();
                });
                widget.controller.jumpToPage(page);
              },
              label: (_currentValue + 1).toString(),
              value: _currentValue.toDouble(),
              max: widget.count - 1,
              min: 0,
              divisions: widget.count - 1 > 0 ? widget.count - 1 : null,
              onChanged: (v) {
                setState(() {
                  _currentValue = v.toInt();
                });
              },
            ),
          ),
          Text(
            widget.count.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
