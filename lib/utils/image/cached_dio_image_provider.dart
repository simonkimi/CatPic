import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedDioImageProvider extends ImageProvider<CachedDioImageProvider> {
  final Dio dio;
  final String url;
  final double scale;
  final String cachedKey;

  CachedDioImageProvider({
    @required this.cachedKey,
    @required this.url,
    @required this.dio,
    this.scale = 1.0,
  });

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

  Future<ui.Codec> _loadAsync(CachedDioImageProvider key, DecoderCallback decode,
      StreamController<ImageChunkEvent> chunkEvents) async {
    var cached = await getCached();
    if (cached != null) {
      return await decode(cached);
    }

    var rsp = await dio.get<List<int>>(url,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: received,
            expectedTotalBytes: total,
          ));
        });
    var bytes = Uint8List.fromList(rsp.data);
    if (bytes.lengthInBytes == 0) {
      throw StateError('$url is empty and cannot be loaded as an image.');
    }
    setCached(bytes);
    return await decode(bytes);
  }

  Future<Uint8List> getCached() async {
    var cachedManager = DefaultCacheManager();
    var fileInfo = await cachedManager.getFileFromCache(cachedKey);
    if (fileInfo != null && fileInfo.file != null) {
      return await fileInfo.file.readAsBytes();
    }
    return null;
  }

  Future<void> setCached(Uint8List imageBytes) async {
    var cachedManager = DefaultCacheManager();
    await cachedManager.putFile(cachedKey, imageBytes);
  }

  InformationCollector _imageStreamInformationCollector(
      CachedDioImageProvider key) {
    InformationCollector collector;
    assert(() {
      collector = () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<CachedDioImageProvider>(
              'Image key', key),
        ];
      };
      return true;
    }());
    return collector;
  }
}
