import 'dart:core' as core;

import 'dart:core';

extension DebugHelper<T> on T {
  void print([String? tag]) => core.print('${tag ?? ''} $this');
}

var _timeRec = DateTime.now();

void printTimeLine(String tag) {
  final newTime = DateTime.now();
  final diff = newTime.difference(_timeRec).toString();
  _timeRec = newTime;
  print('$tag: ${diff.toString()}');
}

void startTimeLine() {
  _timeRec = DateTime.now();
}
