import 'dart:math';

import 'package:catpic/data/models/gen/eh_storage.pbenum.dart';

extension DisplayTypePage on DisplayType {
  int toRealIndex(int real) {
    switch (this) {
      case DisplayType.Single:
        return real;
      case DisplayType.DoubleNormal:
        return real * 2;
      case DisplayType.DoubleCover:
      default:
        return max((real - 1) * 2 + 1, 0);
    }
  }

  int toDisplayIndex(int display) {
    switch (this) {
      case DisplayType.Single:
        return display;
      case DisplayType.DoubleNormal:
        return (display / 2).ceil();
      case DisplayType.DoubleCover:
      default:
        return ((display + 1) / 2).floor();
    }
  }

  DisplayType next() {
    switch (this) {
      case DisplayType.Single:
        return DisplayType.DoubleNormal;
      case DisplayType.DoubleNormal:
        return DisplayType.DoubleCover;
      case DisplayType.DoubleCover:
      default:
        return DisplayType.Single;
    }
  }
}
