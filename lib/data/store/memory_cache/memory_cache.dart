class MemoryCache {
  final _cache = <String, dynamic>{};

  T? get<T>(String key) {
    final entity = _cache[key];
    return entity is T ? entity : null;
  }

  void set(String key, dynamic value) => _cache[key] = value;

  void clean() => _cache.clear();
}
