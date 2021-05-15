import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImageClipper extends CustomPainter {
  const ImageClipper(
    this.image, {
    this.offset = 0,
    this.width = 0,
    this.height = 0,
  });

  final ui.Image image;

  final double offset;
  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(offset, 0, width, height),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PreviewClipper extends CustomClipper<Path> {
  PreviewClipper({
    this.offset = 0.0,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;
  final double offset;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(offset, 0.0);
    path.lineTo(offset + width, 0.0);
    path.lineTo(offset + width, height);
    path.lineTo(offset, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
