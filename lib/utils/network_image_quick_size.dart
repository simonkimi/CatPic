// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'image_size.dart';

typedef ImageSizeCallback = void Function(Size size);

@immutable
class NetworkImageQuickSize extends ImageProvider<NetworkImageQuickSize> {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments [url] and [scale] must not be null.
  const NetworkImageQuickSize(
    this.url, {
    this.scale = 1.0,
    this.headers,
    this.onImageSize,
  })  : assert(url != null),
        assert(scale != null);

  final ImageSizeCallback? onImageSize;

  final String url;

  final double scale;

  final Map<String, String>? headers;

  @override
  Future<NetworkImageQuickSize> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<NetworkImageQuickSize>(this);
  }

  @override
  ImageStreamCompleter load(NetworkImageQuickSize key, DecoderCallback decode) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<NetworkImageQuickSize>('Image key', key),
        ];
      },
    );
  }

  // Do not access this field directly; use [_httpClient] instead.
  // We set `autoUncompress` to false to ensure that we can trust the value of
  // the `Content-Length` HTTP header. We automatically uncompress the content
  // in our call to [consolidateHttpClientResponseBytes].
  static final HttpClient _sharedHttpClient = HttpClient()
    ..autoUncompress = false;

  static HttpClient get _httpClient {
    HttpClient client = _sharedHttpClient;
    assert(() {
      if (debugNetworkImageHttpClientProvider != null)
        client = debugNetworkImageHttpClientProvider!();
      return true;
    }());
    return client;
  }

  Future<ui.Codec> _loadAsync(
    NetworkImageQuickSize key,
    StreamController<ImageChunkEvent> chunkEvents,
    DecoderCallback decode,
  ) async {
    try {
      assert(key == this);

      final Uri resolved = Uri.base.resolve(key.url);

      final HttpClientRequest request = await _httpClient.getUrl(resolved);

      headers?.forEach((String name, String value) {
        request.headers.add(name, value);
      });
      final HttpClientResponse response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        // The network may be only temporarily unavailable, or the file will be
        // added on the server later. Avoid having future calls to resolve
        // fail to check the network again.
        await response.drain<List<int>>();
        throw NetworkImageLoadException(
            statusCode: response.statusCode, uri: resolved);
      }

      final Uint8List bytes =
          await consolidateHttpClientResponseBytesAndGetImageSize(
        response,
        onBytesReceived: (int cumulative, int? total) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: cumulative,
            expectedTotalBytes: total,
          ));
        },
        onImageSize: onImageSize,
      );
      if (bytes.lengthInBytes == 0)
        throw Exception('NetworkImageQuickSize is an empty file: $resolved');

      return decode(bytes);
    } catch (e) {
      // Depending on where the exception was thrown, the image cache may not
      // have had a chance to track the key in the cache at all.
      // Schedule a microtask to give the cache a chance to add the key.
      scheduleMicrotask(() {
        PaintingBinding.instance!.imageCache!.evict(key);
      });
      rethrow;
    } finally {
      chunkEvents.close();
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is NetworkImageQuickSize &&
        other.url == url &&
        other.scale == scale;
  }

  @override
  int get hashCode => ui.hashValues(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'NetworkImageQuickSize')}("$url", scale: $scale)';
}

Future<Uint8List> consolidateHttpClientResponseBytesAndGetImageSize(
  HttpClientResponse response, {
  bool autoUncompress = true,
  BytesReceivedCallback? onBytesReceived,
  ImageSizeCallback? onImageSize,
}) {
  assert(autoUncompress != null);
  final Completer<Uint8List> completer = Completer<Uint8List>.sync();

  final _OutputBuffer output = _OutputBuffer();
  ByteConversionSink sink = output;
  int? expectedContentLength = response.contentLength;
  if (expectedContentLength == -1) expectedContentLength = null;
  switch (response.compressionState) {
    case HttpClientResponseCompressionState.compressed:
      if (autoUncompress) {
        // We need to un-compress the bytes as they come in.
        sink = gzip.decoder.startChunkedConversion(output);
      }
      break;
    case HttpClientResponseCompressionState.decompressed:
      // response.contentLength will not match our bytes stream, so we declare
      // that we don't know the expected content length.
      expectedContentLength = null;
      break;
    case HttpClientResponseCompressionState.notCompressed:
      // Fall-through.
      break;
  }

  int bytesReceived = 0;
  bool obtainedImageSize = false;
  late final StreamSubscription<List<int>> subscription;
  subscription = response.listen((List<int> chunk) {
    sink.add(chunk);
    if (onBytesReceived != null) {
      bytesReceived += chunk.length;
      try {
        if ((!obtainedImageSize) && onImageSize != null) {
          if (bytesReceived > 32) {
            final size = ImageSize.getSize(output.getBytes());
            if (size != null) {
              obtainedImageSize = true;
              onImageSize(Size(size.width.toDouble(), size.height.toDouble()));
            }
            if (bytesReceived > 512 && size == null) {
              obtainedImageSize = true;
            }
          }
        }
        onBytesReceived(bytesReceived, expectedContentLength);
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
        subscription.cancel();
        return;
      }
    }
  }, onDone: () {
    sink.close();
    completer.complete(output.bytes);
  }, onError: completer.completeError, cancelOnError: true);

  return completer.future;
}

class _OutputBuffer extends ByteConversionSinkBase {
  List<List<int>>? _chunks = <List<int>>[];
  int _contentLength = 0;
  Uint8List? _bytes;

  @override
  void add(List<int> chunk) {
    assert(_bytes == null);
    _chunks!.add(chunk);
    _contentLength += chunk.length;
  }

  @override
  void close() {
    if (_bytes != null) {
      // We've already been closed; this is a no-op
      return;
    }
    _bytes = Uint8List(_contentLength);
    int offset = 0;
    for (final List<int> chunk in _chunks!) {
      _bytes!.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    _chunks = null;
  }

  Uint8List getBytes() {
    final bytes = Uint8List(_contentLength);
    int offset = 0;
    for (final List<int> chunk in _chunks!) {
      bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return bytes;
  }

  Uint8List get bytes {
    assert(_bytes != null);
    return _bytes!;
  }
}
