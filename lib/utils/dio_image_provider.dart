import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:catpic/main.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:path/path.dart' as p;

typedef UrlBuilder = Future<String> Function();

class DioImageProvider extends ImageProvider<DioImageProvider> {
  DioImageProvider({
    this.url,
    this.dio,
    this.scale = 1.0,
    this.urlBuilder,
  }) : assert(urlBuilder != null || url != null);

  final Dio? dio;
  final String? url;
  final double scale;
  final UrlBuilder? urlBuilder;

  var _cancelToken = CancelToken();

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
    _cancelToken = CancelToken();
    try {
      final imageUrl = url ?? await urlBuilder!();
      final rsp = await (dio ?? Dio()).get<List<int>>(imageUrl,
          cancelToken: _cancelToken,
          options: settingStore.dioCacheOptions
              .copyWith(
                policy: CachePolicy.request,
                keyBuilder: (req) => imageUrl,
              )
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
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        throw StateError('Load cancel');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  void cancel() {
    _cancelToken.cancel();
  }
}

enum LoadingState {
  PENDING,
  DOWNLOADING,
  DONE,
  ERROR,
}

class DioVideoProvider {
  DioVideoProvider({
    required this.url,
    this.dio,
    this.scale = 1.0,
  });

  final Dio? dio;
  final String url;
  final double scale;

  final StreamController<ImageChunkEvent> chunkEvent =
      StreamController<ImageChunkEvent>.broadcast();

  var _cancelToken = CancelToken();

  var loadingState = LoadingState.PENDING;

  Stream<ImageChunkEvent> get stream => chunkEvent.stream;

  String get fileUrl {
    final fileName = md5.convert(utf8.encode(url)).toString();
    return p.join(settingStore.documentDir, 'cache', 'video', '$fileName.mp4');
  }

  File get file => File(fileUrl);

  LoadingState get state => loadingState;

  Future<void> resolve() async {
    if (loadingState == LoadingState.PENDING ||
        loadingState == LoadingState.ERROR) {
      _cancelToken = CancelToken();
      loadingState = LoadingState.DOWNLOADING;
      chunkEvent.add(const ImageChunkEvent(
          cumulativeBytesLoaded: 0, expectedTotalBytes: 0));
      final cacheUri = p.join(settingStore.documentDir, 'cache', 'video');
      await Directory(cacheUri).create();
      try {
        final file = File(fileUrl);
        if (file.existsSync()) {
          loadingState = LoadingState.DONE;
          chunkEvent.close();
          return;
        }
      } catch (e) {
        print(e);
      }

      try {
        await (dio ?? Dio()).download(url, fileUrl,
            options: settingStore.dioCacheOptions
                .toOptions()
                .copyWith(responseType: ResponseType.bytes),
            cancelToken: _cancelToken, onReceiveProgress: (received, total) {
          chunkEvent.add(ImageChunkEvent(
            cumulativeBytesLoaded: received,
            expectedTotalBytes: total,
          ));
        });
        chunkEvent.close();
      } on DioError catch (e) {
        if (CancelToken.isCancel(e))
          loadingState = LoadingState.PENDING;
        else
          loadingState = LoadingState.ERROR;
      } catch (e) {
        loadingState = LoadingState.ERROR;
      }
      loadingState = LoadingState.DONE;
    }
  }

  void cancel() {
    _cancelToken.cancel();
  }
}
