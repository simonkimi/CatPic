import 'package:flutter/cupertino.dart';

double px2dp(BuildContext context, double px) {
  var scale = MediaQuery.of(context).devicePixelRatio;
  return px / scale + 0.5;
}

double dp2px(BuildContext context, double dp) {
  var scale = MediaQuery.of(context).devicePixelRatio;
  return dp * scale + 0.5;
}