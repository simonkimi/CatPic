import 'package:flutter/material.dart';

double px2dp(BuildContext context, double px) {
  final scale = MediaQuery.of(context).devicePixelRatio;
  return px / scale + 0.5;
}

double dp2px(BuildContext context, double dp) {
  final scale = MediaQuery.of(context).devicePixelRatio;
  return dp * scale + 0.5;
}