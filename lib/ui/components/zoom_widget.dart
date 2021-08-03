import 'dart:async';

import 'package:flutter/material.dart';
import 'package:catpic/utils/utils.dart';

class ZoomWidget extends StatefulWidget {
  const ZoomWidget({
    Key? key,
    required this.child,
    this.onTapUp,
  }) : super(key: key);

  final Widget child;

  final GestureTapUpCallback? onTapUp;

  @override
  _ZoomWidgetState createState() => _ZoomWidgetState();
}

class _ZoomWidgetState extends State<ZoomWidget> with TickerProviderStateMixin {
  List<double> doubleTapScales = <double>[1.0, 1.2, 1.5];
  final controller = TransformationController();
  late final GestureAnimation _animation;

  @override
  void initState() {
    _animation = GestureAnimation(
      this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: InteractiveViewer(
        child: widget.child,
        maxScale: 5.0,
        transformationController: controller,
      ),
      onTapUp: widget.onTapUp,
      onDoubleTap: () {},
      onDoubleTapDown: (detail) {
        final mx = controller.value.clone();
        final position = detail.globalPosition;
        final currentScale = mx.getMaxScaleOnAxis();
        final currentX = mx.getTranslation().x;
        final currentY = mx.getTranslation().y;
        var index =
            doubleTapScales.indexOf(currentScale.nearList(doubleTapScales)) + 1;
        if (index >= doubleTapScales.length) index = 0;
        final scale = doubleTapScales[index];
        print('$currentScale $scale');
        _animation.animationScale(currentScale, scale);
        _animation.animationOffset(
          Offset(currentX, currentY),
          Offset(-position.dx * (scale - 1), -position.dy * (scale - 1)),
        );
        _animation.forward((event) {
          print(event.scale);
          controller.value = Matrix4.identity()
            ..translate(event.offset.dx, event.offset.dy)
            ..scale(event.scale);
        });
      },
    );
  }
}

class GestureAnimationData {
  GestureAnimationData({required this.scale, required this.offset});

  final Offset offset;
  final double scale;
}

class GestureAnimation {
  GestureAnimation(TickerProvider vsync, {required this.duration}) {
    _offsetController = AnimationController(vsync: vsync, duration: duration)
      ..addListener(() {
        if (_offsetAnimation != null) {
          _offset = _offsetAnimation!.value;
          _stream.add(GestureAnimationData(offset: _offset, scale: _scale));
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          for (final s in subList) s.cancel();
          subList.clear();
        }
      });
    _scaleController = AnimationController(vsync: vsync, duration: duration)
      ..addListener(() {
        if (_scaleAnimation != null) {
          _scale = _scaleAnimation!.value;
          _stream.add(GestureAnimationData(offset: _offset, scale: _scale));
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          for (final s in subList) s.cancel();
          subList.clear();
        }
      });
  }

  final Duration duration;

  final _stream = StreamController<GestureAnimationData>.broadcast();

  final subList = <StreamSubscription<GestureAnimationData>>[];

  double _scale = 0;
  late AnimationController _offsetController;
  Animation<Offset>? _offsetAnimation;

  Offset _offset = Offset.zero;
  late AnimationController _scaleController;
  Animation<double>? _scaleAnimation;

  void animationOffset(Offset? begin, Offset end) {
    _offsetController.stop();
    _offsetController.reset();
    _offsetAnimation =
        _offsetController.drive(Tween<Offset>(begin: begin, end: end));
    _offsetController.forward();
  }

  void animationScale(double? begin, double end) {
    _scaleController.stop();
    _scaleController.reset();
    _scaleAnimation =
        _scaleController.drive(Tween<double>(begin: begin, end: end));
    _scaleController.forward();
  }

  void forward(void Function(GestureAnimationData) listener) {
    final sub = _stream.stream.listen(listener);
    subList.add(sub);
  }

  void dispose() {
    _offsetController.dispose();
    _scaleController.dispose();
    _stream.close();
  }

  void stop() {
    _offsetController.stop();
    _scaleController.stop();
  }
}
