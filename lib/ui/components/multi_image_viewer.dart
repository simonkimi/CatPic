import 'package:catpic/utils/cached_dio_image_provider.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../i18n.dart';
import 'nullable_hero.dart';

class ImageBase {
  const ImageBase({
    required this.imgUrl,
    required this.cachedKey,
    this.heroTag,
  });

  final String imgUrl;
  final String cachedKey;
  final String? heroTag;
}

class MultiImageViewer extends StatefulWidget {
  const MultiImageViewer({
    Key? key,
    this.onScale,
    required this.images,
    required this.index,
    required this.dio,
    this.onIndexChange,
  }) : super(key: key);

  final Dio dio;
  final List<ImageBase> images;
  final int index;
  final ValueChanged<bool>? onScale;
  final ValueChanged<int>? onIndexChange;

  @override
  _MultiImageViewerState createState() => _MultiImageViewerState();
}

class _MultiImageViewerState extends State<MultiImageViewer>
    with TickerProviderStateMixin {
  Animation<double>? _doubleClickAnimation;
  late AnimationController _doubleClickAnimationController;
  late VoidCallback _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0, 3.0];
  late final pageController = PageController(initialPage: widget.index);

  @override
  void initState() {
    super.initState();
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _doubleClickAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImageGesturePageView.builder(
      controller: pageController,
      onPageChanged: widget.onIndexChange,
      itemBuilder: (context, index) {
        final imageBase = widget.images[index];

        return ExtendedImage(
          image: CachedDioImageProvider(
            dio: widget.dio,
            cachedKey: imageBase.cachedKey,
            url: imageBase.imgUrl,
            cachedImg: true,
          ),
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
              inPageView: false,
              initialAlignment: InitialAlignment.center,
              gestureDetailsIsChanged: (ge) {
                widget.onScale?.call((ge?.totalScale ?? 0.0) < 1.2);
              },
            );
          },
          onDoubleTap: _doubleTap,
          loadStateChanged: (state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Builder(
                    builder: (context) {
                      var progress =
                          state.loadingProgress?.expectedTotalBytes != null
                              ? state.loadingProgress!.cumulativeBytesLoaded /
                                  state.loadingProgress!.expectedTotalBytes!
                              : 0.0;
                      progress = progress.isFinite ? progress : 0;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                              value: progress == 0 ? null : progress),
                          const SizedBox(
                            height: 20,
                          ),
                          if (progress == 0)
                            Text(
                              I18n.of(context).connecting,
                              style: const TextStyle(color: Colors.white),
                            )
                          else
                            Text(
                              '${(progress * 100).toStringAsFixed(2)}%',
                              style: const TextStyle(color: Colors.white),
                            )
                        ],
                      );
                    },
                  ),
                );
              case LoadState.completed:
                return NullableHero(
                  // tag: imageBase.heroTag,
                  child: state.completedWidget,
                );
              case LoadState.failed:
                return GestureDetector(
                  onTap: () {
                    state.reLoadImage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          state.lastException.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
            }
          },
        );
      },
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
