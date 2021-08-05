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

class EhImageViewer extends StatefulWidget {
  const EhImageViewer({
    Key? key,
    required this.store,
    this.pageController,
    required this.startIndex,
    this.onCenterTap,
    this.onIndexChange,
  }) : super(key: key);

  final EhReadStore store;
  final PageController? pageController;
  final int startIndex;
  final VoidCallback? onCenterTap;
  final ValueChanged<int>? onIndexChange;

  @override
  _EhImageViewerState createState() => _EhImageViewerState();
}

class _EhImageViewerState extends State<EhImageViewer>
    with TickerProviderStateMixin {
  late final PageController pageController;
  late final EhReadStore store = widget.store;
  final doubleTapScales = <double>[0.99, 2.0, 3.0];

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
    widget.onIndexChange?.call(index);
    final int preloadNum = settingStore.preloadingNumber;
    if (store.readImageList.length <= index) {
      return;
    }

    final imageModel = store.readImageList[index];

    if (imageModel.imageProvider == null) {
      imageModel.requestLoad(true).then((value) {
        imageModel.imageProvider?.resolve(const ImageConfiguration());
      });
    }
    if (preloadNum != 0) {
      // 向后预加载${preloadNum}张图片
      store.readImageList.sublist(index + 1).take(preloadNum).forEach((e) {
        if (e.imageProvider == null) {
          e.requestLoad(true).then((value) {
            e.imageProvider?.resolve(const ImageConfiguration());
          });
        } else {
          e.imageProvider?.resolve(const ImageConfiguration());
        }
      });

      // 向前预加载一张图片
      if (index > 1) {
        final e = store.readImageList[index - 1];
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
    if (left < tap && tap < right) {
      widget.onCenterTap?.call();
    } else if (tap < left) {
      if (store.currentIndex - 1 >= 0)
        pageController.jumpToPage(store.currentIndex - 1);
    } else {
      if (store.currentIndex + 1 < store.imageCount)
        pageController.jumpToPage(store.currentIndex + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      pageController: pageController,
      onPageChanged: onPageIndexChange,
      itemCount: store.readImageList.length,
      builder: (context, index) {
        return buildPage(context, index);
      },
    );
  }

  PhotoViewGalleryPageOptions buildPage(BuildContext context, int index) {
    final galleryImage = store.readImageList[index];
    final controller = PhotoViewController();

    final animation = ZoomAnimation(
      this,
      duration: const Duration(milliseconds: 200),
    );

    return PhotoViewGalleryPageOptions.customChild(
      minScale: 1.0,
      maxScale: 5.0,
      controller: controller,
      child: Obx(() {
        if (galleryImage.state.value == LoadingState.NONE) {
          return buildLoadingPage(index, 0);
        } else if (galleryImage.state.value == LoadingState.ERROR) {
          return buildErrorPage(galleryImage.lastException);
        } else if (galleryImage.state.value == LoadingState.LOADED) {
          return GestureDetector(
            key: UniqueKey(),
            onTapUp: _onTapUp,
            onDoubleTap: () {},
            onDoubleTapDown: (detail) {

              // 缩放
              final position = detail.globalPosition;
              final currentScale = controller.scale ?? 1.0;
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
            child: ExtendedImage(
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
                                  ? state.loadingProgress!
                                          .cumulativeBytesLoaded /
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
            ),
          );
        }
        return buildErrorPage('奇怪的错误');
      }),
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
