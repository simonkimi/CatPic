import 'package:catpic/ui/pages/eh_page/preview_page/store/read_store.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/store/store.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';

import '../../../../../i18n.dart';
import '../../../../../main.dart';

class EhImageViewer extends StatefulWidget {
  const EhImageViewer({
    Key? key,
    required this.store,
    this.pageController,
    required this.startIndex,
    required this.readStore,
    this.onCenterTap,
    this.onIndexChange,
  }) : super(key: key);

  final EhGalleryStore store;
  final PageController? pageController;
  final int startIndex;
  final ReadStore readStore;
  final VoidCallback? onCenterTap;
  final ValueChanged<int>? onIndexChange;

  @override
  _EhImageViewerState createState() => _EhImageViewerState();
}

class _EhImageViewerState extends State<EhImageViewer>
    with TickerProviderStateMixin {
  Animation<double>? _doubleClickAnimation;
  late final AnimationController _doubleClickAnimationController;
  late VoidCallback _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0, 3.0];

  late final PageController pageController;

  late final EhGalleryStore store = widget.store;
  late final ReadStore readStore = widget.readStore;

  @override
  void initState() {
    super.initState();
    pageController =
        widget.pageController ?? PageController(initialPage: widget.startIndex);
    _doubleClickAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      onPageIndexChange(widget.startIndex);
    });
  }

  Future<void> onPageIndexChange(int index) async {
    widget.onIndexChange?.call(index);
    final int preloadNum = settingStore.preloadingNumber;

    if (store.readImageList[index].imageProvider == null) {
      await store.loadPage(
        (index / 40).floor() + 1,
        false,
      );
    }

    store.readImageList.sublist(index + 1).take(preloadNum).forEach((e) {
      if (e.imageProvider == null) {
        store
            .loadPage((store.readImageList.indexOf(e) / 40).floor() + 1, false)
            .then((value) {
          e.imageProvider?.resolve(const ImageConfiguration());
        });
      } else {
        e.imageProvider!.resolve(const ImageConfiguration());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final onTapUp = (TapUpDetails details) {
      final totalW = MediaQuery.of(context).size.width;
      final left = totalW / 3;
      final right = left * 2;
      final tap = details.globalPosition.dx;
      if (left < tap && tap < right) {
        widget.onCenterTap?.call();
      } else if (tap < left) {
        if (readStore.currentIndex - 1 > 0)
          pageController.jumpToPage(readStore.currentIndex - 1);
      } else {
        if (readStore.currentIndex + 1 < store.imageCount)
          pageController.jumpToPage(readStore.currentIndex + 1);
      }
    };

    return ExtendedImageGesturePageView.builder(
      controller: pageController,
      onPageChanged: onPageIndexChange,
      itemCount: store.readImageList.length,
      itemBuilder: (context, index) {
        final galleryImage = store.readImageList[index];
        return Obx(() {
          if (galleryImage.state.value == LoadingState.NONE) {
            return buildLoadingPage(index, 0);
          }
          if (galleryImage.state.value == LoadingState.LOADED) {
            return GestureDetector(
              key: UniqueKey(),
              onTapUp: onTapUp,
              child: ExtendedImage(
                key: UniqueKey(),
                image: galleryImage.imageProvider!,
                enableLoadState: true,
                handleLoadingProgress: true,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: (state) {
                  return GestureConfig(
                    minScale: 0.9,
                    animationMinScale: 0.7,
                    maxScale: 5.0,
                    animationMaxScale: 5.0,
                    speed: 1.0,
                    inertialSpeed: 100.0,
                    initialScale: 1.0,
                    inPageView: true,
                    initialAlignment: InitialAlignment.center,
                  );
                },
                onDoubleTap: _doubleTap,
                loadStateChanged: (state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                        child: Builder(
                          builder: (context) {
                            final progress = state
                                        .loadingProgress?.expectedTotalBytes !=
                                    null
                                ? state.loadingProgress!.cumulativeBytesLoaded /
                                    state.loadingProgress!.expectedTotalBytes!
                                : 0.0;
                            return buildLoadingPage(index, progress);
                          },
                        ),
                      );
                    case LoadState.completed:
                      return null;
                    case LoadState.failed:
                      return buildErrorPage(state.lastException);
                  }
                },
              ),
            );
          }
          return buildErrorPage('奇怪的错误');
        });
      },
    );
  }

  Widget buildErrorPage(Object? e) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Center(
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
              e.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                decoration: TextDecoration.none,
              ),
            ),
          ],
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

  void _doubleTap(ExtendedImageGestureState state) {
    final Offset pointerDownPosition = state.pointerDownPosition!;

    _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);
    _doubleClickAnimationController.stop();
    _doubleClickAnimationController.reset();

    final begin = state.gestureDetails?.totalScale ?? 0;
    var endIndex = doubleTapScales.indexOf(begin) + 1;
    if (endIndex >= doubleTapScales.length) {
      endIndex -= doubleTapScales.length;
    }
    final end = doubleTapScales[endIndex];

    _doubleClickAnimationListener = () {
      state.handleDoubleTap(
          scale: _doubleClickAnimation!.value,
          doubleTapPosition: pointerDownPosition);
    };
    _doubleClickAnimation = _doubleClickAnimationController
        .drive(Tween<double>(begin: begin, end: end));
    _doubleClickAnimation!.addListener(_doubleClickAnimationListener);
    _doubleClickAnimationController.forward();
  }
}
