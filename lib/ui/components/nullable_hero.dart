import 'package:flutter/material.dart';

class NullableHero extends StatelessWidget {
  const NullableHero({Key? key, this.tag, required this.child})
      : super(key: key);
  final String? tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return tag != null ? Hero(tag: tag!, child: child) : child;
  }
}
