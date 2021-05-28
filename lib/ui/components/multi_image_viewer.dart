import 'package:catpic/main.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'package:catpic/i18n.dart';
import 'package:video_player/video_player.dart';
import 'nullable_hero.dart';

typedef FutureItemBuilder = Future<String> Function(int index);

typedef ItemBuilder = String Function(int index);

class MultiImageViewer extends StatefulWidget {
  const MultiImageViewer.async({
    Key? key,
    required this.index,
    required this.dio,
    this.onIndexChange,
    required this.itemCount,
    this.futureItemBuilder,
    this.pageController,
    this.onCenterTap,
  })  : hasVideo = false,
        itemBuilder = null,
        previewBuilder = null,
        super(key: key);

  const MultiImageViewer.videoImage({
    Key? key,
    required this.index,
    required this.dio,
    this.onIndexChange,
    required this.itemCount,
    this.itemBuilder,
    this.pageController,
    this.previewBuilder,
    this.onCenterTap,
  })  : hasVideo = true,
        futureItemBuilder = null,
        super(key: key);

  final Dio dio;
  final int index;
  final ValueChanged<int>? onIndexChange;
  final FutureItemBuilder? futureItemBuilder;
  final ItemBuilder? itemBuilder;
  final int itemCount;
  final bool hasVideo;
  final PageController? pageController;
  final VoidCallback? onCenterTap;
  final ItemBuilder? previewBuilder;

  @override
  _MultiImageViewerState createState() => _MultiImageViewerState();
}

class _MultiImageViewerState extends State<MultiImageViewer>
    with TickerProviderStateMixin {
  Animation<double>? _doubleClickAnimation;
  late final AnimationController _doubleClickAnimationController;
  late VoidCallback _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0, 3.0];
  late final PageController pageController;
  late final List<dynamic> contentProvider;

  final videoPlayerControllerMap = <int, VideoPlayerController>{};

  @override
  void initState() {
    super.initState();
    if (widget.hasVideo) {
      contentProvider = List.generate(widget.itemCount, (index) {
        if (widget.itemBuilder!(index).endsWith('.mp4'))
          return DioVideoProvider(
            dio: widget.dio,
            url: widget.itemBuilder!(index),
          );
        return DioImageProvider(
            dio: widget.dio, url: widget.itemBuilder!(index));
      });
    } else {
      contentProvider = List.generate(
          widget.itemCount,
          (index) => DioImageProvider(
                dio: widget.dio,
                url: widget.itemBuilder?.call(index),
                urlBuilder: () => widget.futureItemBuilder!(index),
              ));
    }

    pageController =
        widget.pageController ?? PageController(initialPage: widget.index);
    _doubleClickAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      onPageIndexChange(widget.index);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _doubleClickAnimationController.dispose();
    contentProvider.whereType<DioVideoProvider>().forEach((element) {
      element.cancel();
    });
    contentProvider.whereType<DioImageProvider>().forEach((element) {
      element.cancel();
    });
    videoPlayerControllerMap.forEach((key, value) {
      value.pause();
      value.dispose();
    });
  }

  void onPageIndexChange(int index) {
    widget.onIndexChange?.call(index);
    final int preloadNum = settingStore.preloadingNumber;
    contentProvider.sublist(index + 1).take(preloadNum).forEach((e) {
      if (e is DioImageProvider) e.resolve(const ImageConfiguration());
    });
    videoPlayerControllerMap.forEach((key, value) {
      value.pause();
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
        pageController.previousPage(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      } else {
        pageController.nextPage(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    };

    return ExtendedImageGesturePageView.builder(
      controller: pageController,
      onPageChanged: onPageIndexChange,
      itemCount: contentProvider.length,
      itemBuilder: (context, index) {
        final provider = contentProvider[index];
        if (provider is DioImageProvider) {
          return GestureDetector(
            onTapUp: onTapUp,
            child: ExtendedImage(
              key: UniqueKey(),
              image: provider,
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
                          var progress =
                              state.loadingProgress?.expectedTotalBytes != null
                                  ? state.loadingProgress!
                                          .cumulativeBytesLoaded /
                                      state.loadingProgress!.expectedTotalBytes!
                                  : 0.0;
                          progress = progress.isFinite ? progress : 0;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                  value: progress == 0 ? null : progress),
                              const SizedBox(height: 20),
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
                              state.lastException.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                }
              },
            ),
          );
        } else {
          final videoProvider = provider as DioVideoProvider;
          return StreamBuilder<ImageChunkEvent>(
            stream: provider.stream,
            builder: (context, snapshot) {
              final playerState = videoPlayerControllerMap[index]?.value;
              if (provider.state == LoadingState.PENDING ||
                  (playerState?.isInitialized ?? false) &&
                      !(playerState?.isPlaying ?? false)) {
                return InkWell(
                  onTap: () {
                    if (playerState?.isInitialized ?? false) {
                      videoPlayerControllerMap[index]!.play();
                      setState(() {});
                    } else {
                      provider.resolve();
                    }
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ExtendedImage(
                        image: DioImageProvider(
                          dio: widget.dio,
                          url: widget.previewBuilder!(index),
                        ),
                        handleLoadingProgress: true,
                        fit: BoxFit.contain,
                      ),
                      Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Material(
                            shape: CircleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                  style: BorderStyle.solid),
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return StatefulBuilder(builder: (context, setState) {
                  if (videoPlayerControllerMap[index] == null) {
                    videoPlayerControllerMap[index] =
                        VideoPlayerController.file(videoProvider.file)
                          ..initialize().then((value) {
                            videoPlayerControllerMap.forEach((key, value) {
                              value.pause();
                            });
                            videoPlayerControllerMap[index]!
                              ..play()
                              ..setLooping(true);
                            setState(() {});
                          });
                  }

                  return Center(
                    child: AspectRatio(
                      aspectRatio:
                          videoPlayerControllerMap[index]!.value.aspectRatio,
                      child: VideoPlayer(videoPlayerControllerMap[index]!),
                    ),
                  );
                });
              }
              var progress = snapshot.data?.expectedTotalBytes != null
                  ? snapshot.data!.cumulativeBytesLoaded /
                      snapshot.data!.expectedTotalBytes!
                  : 0.0;
              progress = progress.isFinite ? progress : 0;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      value: progress == 0 ? null : progress),
                  const SizedBox(height: 20),
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
          );
        }
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
