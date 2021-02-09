import 'package:catpic/ui/components/cached_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

typedef DoubleClickAnimationListener = void Function();

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({
    Key key,
    this.imgUrl,
  }) : super(key: key);

  final String imgUrl;

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> with TickerProviderStateMixin {

  Animation<double> _doubleClickAnimation;
  AnimationController _doubleClickAnimationController;
  DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0, 4.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: buildBody(),
    );
  }


  @override
  void initState() {
    super.initState();
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
  }

  Widget buildBody() {
    return CachedDioImage(
      imgUrl: widget.imgUrl,
      imageBuilder: (context, imgData) {
        return Center(
          child: ExtendedImage(
            width: double.infinity,
            height: double.infinity,
            image: MemoryImage(imgData),
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
              );
            },
            onDoubleTap: _doubleTap,
          ),
        );
      },
      errorBuilder: (context, err) {
        return Center(
          child: Text(err.toString()),
        );
      },
      loadingBuilder: (_, progress) {
        return Center(
          child: CircularProgressIndicator(
            value: ((progress.expectedTotalBytes ?? 0) != 0) &&
                ((progress.cumulativeBytesLoaded ?? 0) != 0)
                ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes
                : 0.0,
          ),
        );
      },
    );
  }

  void _doubleTap(ExtendedImageGestureState state) {
    final Offset pointerDownPosition = state.pointerDownPosition;
    final double begin = state.gestureDetails.totalScale;
    double end;
    _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);
    _doubleClickAnimationController.stop();
    _doubleClickAnimationController.reset();

    final beginIndex = doubleTapScales.indexOf(begin);
    var endIndex = beginIndex + 1;
    if (endIndex >= doubleTapScales.length) {
      endIndex -= doubleTapScales.length;
    }
    end = doubleTapScales[endIndex];

    _doubleClickAnimationListener = () {
      state.handleDoubleTap(
          scale: _doubleClickAnimation.value,
          doubleTapPosition: pointerDownPosition);
    };
    _doubleClickAnimation = _doubleClickAnimationController
        .drive(Tween<double>(begin: begin, end: end));
    _doubleClickAnimation.addListener(_doubleClickAnimationListener);
    _doubleClickAnimationController.forward();
  }
}