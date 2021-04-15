import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedDioImageProvider extends ImageProvider<CachedDioImageProvider> {
  CachedDioImageProvider({
    required this.cachedKey,
    required this.url,
    required this.dio,
    this.cachedImg = false,
    this.scale = 1.0,
  });

  final Dio dio;
  final String url;
  final double scale;
  final String cachedKey;
  final bool cachedImg;

  @override
  ImageStreamCompleter load(
      CachedDioImageProvider key, DecoderCallback decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();
    // chunkEvents.stream.listen((event) {print(event);});
    return MultiFrameImageStreamCompleter(
      chunkEvents: chunkEvents.stream,
      codec: _loadAsync(key, decode, chunkEvents),
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<CachedDioImageProvider>('Image key', key),
        ];
      },
    );
  }

  @override
  Future<CachedDioImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CachedDioImageProvider>(this);
  }

  Future<ui.Codec> _loadAsync(
      CachedDioImageProvider key,
      DecoderCallback decode,
      StreamController<ImageChunkEvent> chunkEvents) async {
    if (cachedImg) {
      final cached = await _getCached();
      if (cached != null) {
        return await decode(cached);
      }
    }
    final rsp = await dio
        .get<List<int>>(url, options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (received, total) {
      chunkEvents.add(ImageChunkEvent(
        cumulativeBytesLoaded: received,
        expectedTotalBytes: total,
      ));
    });
    if (rsp.data == null) {
      throw StateError('$url is empty and cannot be loaded as an image.');
    }
    final bytes = Uint8List.fromList(rsp.data!);
    if (bytes.lengthInBytes == 0) {
      throw StateError('$url is empty and cannot be loaded as an image.');
    }
    _setCached(bytes);
    return await decode(bytes);
  }

  Future<Uint8List?> _getCached() async {
    final cachedManager = DefaultCacheManager();
    final fileInfo = await cachedManager.getFileFromCache(cachedKey);
    if (fileInfo != null) {
      return await fileInfo.file.readAsBytes();
    }
    return null;
  }

  Future<void> _setCached(Uint8List imageBytes) async {
    final cachedManager = DefaultCacheManager();
    await cachedManager.putFile(cachedKey, imageBytes);
  }
}
