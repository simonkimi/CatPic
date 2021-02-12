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
    @required this.cachedKey,
    @required this.url,
    @required this.dio,
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
      CachedDioImageProvider key,
      Future<ui.Codec> Function(Uint8List bytes,
              {bool allowUpscaling, int cacheHeight, int cacheWidth})
          decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
        chunkEvents: chunkEvents.stream,
        codec: _loadAsync(key, decode, chunkEvents),
        scale: key.scale,
        debugLabel: key.url,
        informationCollector: _imageStreamInformationCollector(key));
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
      final cached = await getCached();
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
    final bytes = Uint8List.fromList(rsp.data);
    if (bytes.lengthInBytes == 0) {
      throw StateError('$url is empty and cannot be loaded as an image.');
    }
    setCached(bytes);
    return await decode(bytes);
  }

  Future<Uint8List> getCached() async {
    final cachedManager = DefaultCacheManager();
    final fileInfo = await cachedManager.getFileFromCache(cachedKey);
    if (fileInfo != null && fileInfo.file != null) {
      return await fileInfo.file.readAsBytes();
    }
    return null;
  }

  Future<void> setCached(Uint8List imageBytes) async {
    final cachedManager = DefaultCacheManager();
    await cachedManager.putFile(cachedKey, imageBytes);
  }

  InformationCollector _imageStreamInformationCollector(
      CachedDioImageProvider key) {
    InformationCollector collector;
    assert(() {
      collector = () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<CachedDioImageProvider>('Image key', key),
        ];
      };
      return true;
    }());
    return collector;
  }
}
