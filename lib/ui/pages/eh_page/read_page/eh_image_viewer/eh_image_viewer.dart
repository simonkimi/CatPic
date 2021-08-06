import 'dart:math';

import 'package:catpic/ui/components/zoom_widget.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/store/store.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:catpic/utils/utils.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:catpic/data/models/gen/eh_gallery_img.pb.dart';

import '../read_page.dart';

class EhImageViewer extends StatefulWidget {
  const EhImageViewer({
    Key? key,
    required this.store,
    this.pageController,
    required this.startIndex,
    this.onCenterTap,
    this.onIndexChange,
    required this.pageViewerState,
  }) : super(key: key);

  final EhReadStore store;
  final PageController? pageController;
  final int startIndex;
  final VoidCallback? onCenterTap;
  final ValueChanged<int>? onIndexChange;
  final PageViewerState pageViewerState;

  @override
  _EhImageViewerState createState() => _EhImageViewerState();
}

class _EhImageViewerState extends State<EhImageViewer>
    with TickerProviderStateMixin {
  late final PageController pageController;
  late final EhReadStore store = widget.store;
  final doubleTapScales = <double>[0.99, 2.0, 3.0];

  int get pageCount {
    if (widget.pageViewerState == PageViewerState.Single)
      return store.readImageList.length;
    else if (widget.pageViewerState == PageViewerState.DoubleCover)
      return 1 + ((store.readImageList.length - 1) / 2).ceil();
    else
      return (store.readImageList.length / 2).ceil();
  }

  @override
  void initState() {
    super.initState();
    pageController =
        widget.pageController ?? PageController(initialPage: widget.startIndex);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      pageController.jumpToPage(widget.startIndex);
      onPageIndexChange(widget.startIndex);
    });
  }

  Future<void> onPageIndexChange(int index) async {
    final state = widget.pageViewerState;

    final realIndex = state.toRealIndex(index);

    widget.onIndexChange?.call(realIndex);
    final int preloadNum = settingStore.preloadingNumber;
    if (store.readImageList.length <= realIndex) {
      return;
    }

    final imageModel = store.readImageList[realIndex];

    if (imageModel.imageProvider == null) {
      imageModel.requestLoad(true).then((value) {
        imageModel.imageProvider?.resolve(const ImageConfiguration());
      });
    }
    if (preloadNum != 0) {
      // 向后预加载${preloadNum}张图片
      store.readImageList.sublist(realIndex + 1).take(preloadNum).forEach((e) {
        if (e.imageProvider == null) {
          e.requestLoad(true).then((value) {
            e.imageProvider?.resolve(const ImageConfiguration());
          });
        } else {
          e.imageProvider?.resolve(const ImageConfiguration());
        }
      });

      // 向前预加载一张图片
      if (realIndex > 1) {
        final e = store.readImageList[realIndex - 1];
        if (e.imageProvider == null) {
          e.requestLoad(true).then((value) {
            e.imageProvider?.resolve(const ImageConfiguration());
          });
        } else {
          e.imageProvider?.resolve(const ImageConfiguration());
        }
      }
    }
  }

  void _onTapUp(TapUpDetails details) {
    final totalW = MediaQuery.of(context).size.width;
    final left = totalW / 3;
    final right = left * 2;
    final tap = details.globalPosition.dx;

    final index = pageController.page?.toInt() ?? 0;

    if (left < tap && tap < right) {
      widget.onCenterTap?.call();
    } else if (tap < left) {
      if (index - 1 >= 0) pageController.jumpToPage(index - 1);
    } else {
      if (index + 1 < store.imageCount) pageController.jumpToPage(index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      pageController: pageController,
      onPageChanged: onPageIndexChange,
      itemCount: pageCount,
      builder: (context, index) {
        return buildPage(context, index);
      },
    );
  }

  PhotoViewGalleryPageOptions buildPage(BuildContext context, int index) {
    final controller = PhotoViewController();
    final animation = ZoomAnimation(
      this,
      duration: const Duration(milliseconds: 200),
    );
    if (widget.pageViewerState == PageViewerState.Single || // 单面情况
        (widget.pageViewerState == PageViewerState.DoubleCover && // 双面, 封面单独占一面
            index == 0) || // 双面封面单独站一面下, 有独立页面
        (widget.pageViewerState == PageViewerState.DoubleCover &&
            store.imageCount.isEven &&
            index == pageCount - 1) || // 普通双面多一面
        (widget.pageViewerState == PageViewerState.DoubleNormal &&
            store.imageCount.isOdd &&
            index == pageCount - 1)) {
      late final int index1;

      switch (widget.pageViewerState) {
        case PageViewerState.Single:
          index1 = index;
          break;
        case PageViewerState.DoubleNormal:
          index1 = index * 2;
          break;
        case PageViewerState.DoubleCover:
          index1 = max((index - 1) * 2 + 1, 0);
          break;
      }

      final galleryImage = store.readImageList[index];

      return PhotoViewGalleryPageOptions.customChild(
        minScale: 1.0,
        maxScale: 5.0,
        controller: controller,
        child: buildPageOuter(
            child: buildImageLoading(
                context: context,
                index: index1,
                galleryImage: galleryImage,
                child: buildZoomWidget(
                  context: context,
                  controller: controller,
                  animation: animation,
                  child: buildImagePage(
                    context: context,
                    index: index1,
                    galleryImage: galleryImage,
                  ),
                ))),
      );
    } else {
      late final int index1;
      if (widget.pageViewerState == PageViewerState.DoubleCover) {
        index1 = (index - 1) * 2 + 1;
      } else {
        index1 = index * 2;
      }

      final gallery1 = store.readImageList[index1];
      final gallery2 = store.readImageList[index1 + 1];
      return PhotoViewGalleryPageOptions.customChild(
        minScale: 1.0,
        maxScale: 5.0,
        controller: controller,
        child: buildPageOuter(
            child: buildZoomWidget(
          context: context,
          controller: controller,
          animation: animation,
          child: Row(
            children: [
              Expanded(
                child: buildImageLoading(
                  context: context,
                  index: index1,
                  galleryImage: gallery1,
                  child: buildImagePage(
                    context: context,
                    index: index1,
                    galleryImage: gallery1,
                  ),
                ),
              ),
              Expanded(
                child: buildImageLoading(
                  context: context,
                  index: index1 + 1,
                  galleryImage: gallery2,
                  child: buildImagePage(
                    context: context,
                    index: index1 + 1,
                    galleryImage: gallery2,
                  ),
                ),
              ),
            ],
          ),
        )),
      );
    }
  }

  Widget buildImageLoading({
    required BuildContext context,
    required int index,
    required ReadImgModel<GalleryImgModel> galleryImage,
    required Widget child,
  }) {
    return Obx(() {
      if (galleryImage.state.value == LoadingState.NONE) {
        return buildLoadingPage(index, 0);
      } else if (galleryImage.state.value == LoadingState.ERROR) {
        return buildErrorPage(galleryImage.lastException);
      } else if (galleryImage.state.value == LoadingState.LOADED) {
        return child;
      }
      return buildErrorPage('奇怪的错误');
    });
  }

  Widget buildPageOuter({required Widget child}) {
    return GestureDetector(
      onTapUp: _onTapUp,
      child: child,
    );
  }

  Widget buildZoomWidget({
    required BuildContext context,
    required Widget child,
    required PhotoViewController controller,
    required ZoomAnimation animation,
  }) {
    return GestureDetector(
      key: UniqueKey(),
      onTapUp: _onTapUp,
      onDoubleTap: () {},
      onDoubleTapDown: (detail) {
        // 缩放
        final position = detail.globalPosition;
        final currentScale = controller.scale ?? 1.0;
        var index =
            doubleTapScales.indexOf(currentScale.nearList(doubleTapScales)) + 1;
        if (index >= doubleTapScales.length) index = 0;
        final scale = doubleTapScales[index];
        animation.animationScale(currentScale, scale);

        // 位移
        final mediaSize = MediaQuery.of(context).size;
        final currentX = controller.position.dx;
        final currentY = controller.position.dy;
        final targetX = (mediaSize.width / 2 - position.dx) * (scale - 1);
        final targetY = (mediaSize.height / 2 - position.dy) * (scale - 1);
        animation.animationOffset(
          Offset(currentX, currentY),
          Offset(targetX, targetY),
        );

        animation.listen((model) {
          controller.scale = model.scale;
          controller.position = model.offset;
        });
      },
      child: child,
    );
  }

  Widget buildImagePage(
      {required BuildContext context,
      required int index,
      required ReadImgModel<GalleryImgModel> galleryImage}) {
    return ExtendedImage(
      key: UniqueKey(),
      image: galleryImage.imageProvider!,
      enableLoadState: true,
      handleLoadingProgress: true,
      mode: ExtendedImageMode.gesture,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: Builder(
                builder: (context) {
                  final progress =
                      state.loadingProgress?.expectedTotalBytes != null
                          ? state.loadingProgress!.cumulativeBytesLoaded /
                              state.loadingProgress!.expectedTotalBytes!
                          : 0.0;
                  return buildLoadingPage(index, progress);
                },
              ),
            );
          case LoadState.completed:
            return state.completedWidget;
          case LoadState.failed:
            return buildErrorPage(state.lastException);
        }
      },
    );
  }

  Widget buildErrorPage(Object? e) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                e?.toString() ?? I18n.of(context).network_error,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoadingPage(int index, double progress) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Builder(
        builder: (context) {
          progress = progress.isFinite ? progress : 0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (index + 1).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 60),
              CircularProgressIndicator(value: progress == 0 ? null : progress),
              const SizedBox(height: 20),
              if (progress == 0)
                Text(
                  I18n.of(context).connecting,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.none,
                  ),
                )
              else
                Text(
                  '${(progress * 100).toStringAsFixed(2)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.none,
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
