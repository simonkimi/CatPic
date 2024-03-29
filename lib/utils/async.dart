import 'dart:async';

import 'package:synchronized/synchronized.dart';

class AsyncLoader<T> {
  AsyncLoader(this.func);

  final Future<T> Function() func;
  var _completerOuter = Completer<T>();
  var _completerInner = Completer<T>();
  final _lock = Lock();
  Object? _error;

  Future<T> _load() async {
    _completerInner.complete(await _lock.synchronized(() async {
      return await func().catchError((Object err) {
        _error = err;
        throw err;
      });
    }));
    return _completerInner.future;
  }

  Future<T> load() {
    if (!_completerOuter.isCompleted) _completerOuter.complete(_load());
    return _completerOuter.future;
  }

  void reset() {
    _completerOuter = Completer<T>();
    _completerInner = Completer<T>();
    _error = null;
  }

  bool isLoadTask() => _completerOuter.isCompleted;

  bool isFinishTask() => _completerInner.isCompleted;

  bool hasError() => _error != null;

  Object? get error => _error;

  bool get locked => _lock.locked;

  bool get inLock => _lock.inLock;
}
