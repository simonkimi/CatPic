import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:catpic/main.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class DioImageProvider extends ImageProvider<DioImageProvider> {
  DioImageProvider({
    required this.url,
    this.dio,
    this.scale = 1.0,
  });

  final Dio? dio;
  final String url;
  final double scale;

  @override
  ImageStreamCompleter load(DioImageProvider key, DecoderCallback decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();
    return MultiFrameImageStreamCompleter(
      chunkEvents: chunkEvents.stream,
      codec: _loadAsync(key, decode, chunkEvents),
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<DioImageProvider>('Image key', key),
        ];
      },
    );
  }

  @override
  Future<DioImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DioImageProvider>(this);
  }

  Future<ui.Codec> _loadAsync(DioImageProvider key, DecoderCallback decode,
      StreamController<ImageChunkEvent> chunkEvents) async {
    final rsp = await (dio ?? Dio()).get<List<int>>(url,
        options: settingStore.dioCacheOptions
            .copyWith(policy: CachePolicy.request)
            .toOptions()
            .copyWith(responseType: ResponseType.bytes),
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
    return await decode(bytes);
  }
}
