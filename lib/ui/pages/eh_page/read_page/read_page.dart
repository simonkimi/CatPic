import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/eh_image_viewer.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/store/store.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';

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
      appBar: BackAppBar(store: widget.store),
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
        onCenterTap: () {
          widget.store.setPageSliderDisplay(!widget.store.displayPageSlider);
        },
        onIndexChange: (value) {
          widget.store.setIndex(value);
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
                ),
              ),
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  child: PageSlider(
                    count: widget.store.imageCount,
                    controller: pageController,
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
  }) : super(key: key);

  final int count;
  final PageController controller;
  final EhReadStore store;

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final listGlobalKey = GlobalKey();
  final scrollController = ScrollController();

  var _currentValue = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      final page = widget.controller.page?.round() ?? 0;
      if (page != _currentValue) {
        jumpToOffset(page);
        setState(() {
          _currentValue = page;
        });
      }
    });
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
      children: List.generate(widget.count, (index) {
        return InkWell(
          onTap: () {
            widget.controller.jumpToPage(index);
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
  }) : super(key: key);

  final int count;
  final PageController controller;

  @override
  _PageSliderState createState() => _PageSliderState();
}

class _PageSliderState extends State<PageSlider> {
  var _currentValue = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      final page = widget.controller.page?.round() ?? 0;
      if (page != _currentValue) {
        setState(() {
          _currentValue = page;
        });
      }
    });
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
                widget.controller.jumpToPage(value.floor());
                setState(() {
                  _currentValue = value.floor();
                });
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
