import 'dart:async';
import 'dart:math';

import 'package:catpic/data/models/ehentai/eh_storage.dart';
import 'package:catpic/data/models/gen/eh_gallery_img.pb.dart';
import 'package:catpic/data/models/gen/eh_storage.pbenum.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/ui/components/zoom_widget.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/store/store.dart';
import 'package:catpic/utils/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../page_controller.dart';

class EhImageViewer extends StatefulWidget {
  const EhImageViewer({
    Key? key,
    required this.store,
    required this.startIndex,
    required this.readController,
    this.onCenterTap,
    this.onIndexChange,
  }) : super(key: key);

  final EhReadStore store;
  final EhPageController readController;
  final int startIndex;
  final VoidCallback? onCenterTap;
  final ValueChanged<int>? onIndexChange;

  @override
  _EhImageViewerState createState() => _EhImageViewerState();
}

class _EhImageViewerState extends State<EhImageViewer>
    with TickerProviderStateMixin {
  late final EhReadStore store = widget.store;
  final doubleTapScales = <double>[0.99, 2.0, 3.0];
  final indexStream = StreamController<int>.broadcast();
  late final EhPageController readController = widget.readController;

  int get pageCount {
    if (widget.store.adapter.websiteEntity.displayType == DisplayType.Single)
      return store.readImageList.length;
    else if (widget.store.adapter.websiteEntity.displayType ==
        DisplayType.DoubleCover)
      return 1 + ((store.readImageList.length - 1) / 2).ceil();
    else
      return (store.readImageList.length / 2).ceil();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      onPageIndexChange(widget.startIndex);
    });
  }

  Future<void> onPageIndexChange(int index) async {
    final state = widget.store.adapter.websiteEntity.displayType;

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
    final index = readController.index;

    final nextPage = () {
      if (index - 1 >= 0) readController.jumpTo(index - 1);
    };
    final previousPage = () {
      if (index + 1 < store.imageCount) readController.jumpTo(index + 1);
    };

    if (left < tap && tap < right) {
      widget.onCenterTap?.call();
    } else if (tap < left) {
      if (store.adapter.websiteEntity.readAxis == ReadAxis.leftToRight)
        previousPage();
      else
        nextPage();
    } else {
      if (store.adapter.websiteEntity.readAxis == ReadAxis.leftToRight)
        nextPage();
      else
        previousPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return buildMain();
    });
  }

  Widget buildMain() {
    if (store.adapter.websiteEntity.readAxis == ReadAxis.topToButton) {
      final controller = PhotoViewController();
      final animation = ZoomAnimation(
        this,
        duration: const Duration(milliseconds: 200),
      );
      return PhotoView.customChild(
        controller: controller,
        child: buildZoomWidget(
          context: context,
          child: ScrollablePositionedList.builder(
            itemScrollController: readController.listController,
            itemPositionsListener: readController.listPositionsListener,
            itemCount: pageCount,
            itemBuilder: (context, index) {
              return buildPage(context, index, isHorizontal: false);
            },
          ),
          controller: controller,
          animation: animation,
          canZoom: true,
        ),
      );
    } else {
      return PhotoViewGallery.builder(
        pageController: readController.pageController,
        onPageChanged: onPageIndexChange,
        itemCount: pageCount,
        reverse: store.adapter.websiteEntity.readAxis == ReadAxis.rightToLeft,
        builder: (context, index) {
          final controller = PhotoViewController();
          return PhotoViewGalleryPageOptions.customChild(
            minScale: 1.0,
            maxScale: 5.0,
            controller: controller,
            child: buildPage(context, index, controller: controller),
          );
        },
      );
    }
  }

  Widget buildPage(
    BuildContext context,
    int index, {
    bool isHorizontal = true,
    PhotoViewController? controller,
  }) {
    final animation = ZoomAnimation(
      this,
      duration: const Duration(milliseconds: 200),
    );
    final display = widget.store.adapter.websiteEntity.displayType;
    if (display == DisplayType.Single || // 单面情况
        (display == DisplayType.DoubleCover && // 双面, 封面单独占一面
            index == 0) || // 双面封面单独站一面下, 有独立页面
        (display == DisplayType.DoubleCover &&
            store.imageCount.isEven &&
            index == pageCount - 1) || // 普通双面多一面
        (display == DisplayType.DoubleNormal &&
            store.imageCount.isOdd &&
            index == pageCount - 1)) {
      late final int index1;

      switch (display) {
        case DisplayType.Single:
          index1 = index;
          break;
        case DisplayType.DoubleNormal:
          index1 = index * 2;
          break;
        case DisplayType.DoubleCover:
          index1 = max((index - 1) * 2 + 1, 0);
          break;
      }

      final galleryImage = store.readImageList[index];

      return buildPageOuter(
          child: buildImageLoading(
              context: context,
              index: index1,
              galleryImage: galleryImage,
              child: buildZoomWidget(
                canZoom: isHorizontal,
                context: context,
                controller: controller,
                animation: animation,
                child: buildImagePage(
                  context: context,
                  index: index1,
                  galleryImage: galleryImage,
                ),
              )));
    } else {
      late final int index1;
      if (widget.store.adapter.websiteEntity.displayType ==
          DisplayType.DoubleCover) {
        index1 = (index - 1) * 2 + 1;
      } else {
        index1 = index * 2;
      }

      final gallery1 = store.readImageList[index1];
      final gallery2 = store.readImageList[index1 + 1];
      return buildPageOuter(
        child: buildZoomWidget(
          context: context,
          controller: controller,
          animation: animation,
          canZoom: isHorizontal,
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
        ),
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
    required PhotoViewController? controller,
    required ZoomAnimation animation,
    required bool canZoom,
  }) {
    return canZoom
        ? GestureDetector(
            key: UniqueKey(),
            onTapUp: _onTapUp,
            onDoubleTap: () {},
            onDoubleTapDown: (detail) {
              // 缩放
              final position = detail.globalPosition;
              final currentScale = controller!.scale ?? 1.0;
              var index = doubleTapScales
                      .indexOf(currentScale.nearList(doubleTapScales)) +
                  1;
              if (index >= doubleTapScales.length) index = 0;
              final scale = doubleTapScales[index];
              animation.animationScale(currentScale, scale);

              // 位移
              final mediaSize = MediaQuery.of(context).size;
              final currentX = controller.position.dx;
              final currentY = controller.position.dy;
              final targetX = (mediaSize.width / 2 - position.dx) * (scale - 1);
              final targetY =
                  (mediaSize.height / 2 - position.dy) * (scale - 1);
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
          )
        : child;
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
    return AspectRatio(
      aspectRatio: 0.8,
      child: Container(
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
      ),
    );
  }

  Widget buildLoadingPage(int index, double progress) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Container(
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
                CircularProgressIndicator(
                    value: progress == 0 ? null : progress),
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
      ),
    );
  }
}
