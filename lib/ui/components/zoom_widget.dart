import 'dart:async';

import 'package:flutter/material.dart';

class GestureAnimationData {
  GestureAnimationData({required this.scale, required this.offset});

  final Offset offset;
  final double scale;
}

class ZoomAnimation {
  ZoomAnimation(TickerProvider vsync, {required this.duration}) {
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

  void listen(void Function(GestureAnimationData) listener) {
    subList.add(_stream.stream.listen(listener));
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
