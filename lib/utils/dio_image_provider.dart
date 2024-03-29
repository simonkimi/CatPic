import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:catpic/data/bridge/file_helper.dart' as fh;
import 'package:catpic/main.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import 'utils.dart';

typedef AsyncBuilder = Future<DioImageParams> Function();

class DioImageParams {
  const DioImageParams({
    required this.url,
    this.cacheKey,
  });

  final String url;
  final String? cacheKey;
}

class FileParams {
  const FileParams({
    required this.basePath,
    required this.fileName,
  });

  final String basePath;
  final String fileName;
}

@immutable
class DioImageProvider extends ImageProvider<DioImageProvider> {
  DioImageProvider({
    this.url,
    this.dio,
    this.scale = 1.0,
    this.cacheKey,
    this.builder,
    this.fileParams,
  }) : assert(builder != null || url != null);

  final Dio? dio;
  final String? url;
  final double scale;
  final String? cacheKey;
  final AsyncBuilder? builder;
  final FileParams? fileParams;

  final _cancelToken = CancelToken().wrap;

  void dispose() {
    _cancelToken.value.cancel();
  }

  @override
  bool operator ==(Object other) {
    if (other is! DioImageProvider) return false;

    if (other.builder != null || builder != null)
      return other.builder == builder &&
          other.dio == dio &&
          other.scale == scale;

    return other.url == url && other.dio == dio && other.scale == scale;
  }

  @override
  int get hashCode => super.hashCode;

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
    _cancelToken.value = CancelToken();
    try {
      // 尝试从文件里读取
      if (fileParams != null) {
        final fileName = fileParams!.fileName;
        final fileData = await fh.readFile(
          fileParams!.basePath,
          fileName,
        );
        print('加载图片: ${fileParams!.basePath} $fileName ${fileData?.length}');
        if (fileData != null && fileData.isNotEmpty) {
          try {
            return await decode(fileData);
          } on Exception {
            fh.delFile(fileParams!.basePath, fileName);
          }
        }
      }

      String? imgUrl;
      String? cacheKey;

      if (builder != null) {
        final model = await builder!();
        imgUrl = model.url;
        cacheKey = model.cacheKey;
      }
      imgUrl ??= url;
      if (imgUrl == null) throw StateError('imgUrl is null');

      if (imgUrl.endsWith('509.gif') || imgUrl.endsWith('509s.gif'))
        throw StateError('Image 509');

      final key = cacheKey ?? const Uuid().v5(Uuid.NAMESPACE_URL, imgUrl);
      final rsp = await (dio ?? Dio()).get<List<int>>(imgUrl,
          cancelToken: _cancelToken.value,
          options: settingStore.dioCacheOptions
              .copyWith(
                policy: CachePolicy.request,
                keyBuilder: (req) => key,
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

      final data = await decode(bytes);

      if (fileParams != null) {
        var filename = fileParams!.fileName;
        if (!filename.contains('.')) filename += '.' + imgUrl.split('.').last;
        fh.writeFile(fileParams!.basePath, filename, bytes);
      }

      return data;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        throw StateError('Load cancel');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

enum DownloadState {
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

  var downloadState = DownloadState.PENDING;

  Stream<ImageChunkEvent> get stream => chunkEvent.stream;

  String get fileUrl {
    final fileName = md5.convert(utf8.encode(url)).toString();
    return p.join(settingStore.documentDir, 'cache', 'video', '$fileName.mp4');
  }

  File get file => File(fileUrl);

  DownloadState get state => downloadState;

  Future<void> resolve() async {
    if (downloadState == DownloadState.PENDING ||
        downloadState == DownloadState.ERROR) {
      _cancelToken = CancelToken();
      downloadState = DownloadState.DOWNLOADING;
      chunkEvent.add(const ImageChunkEvent(
          cumulativeBytesLoaded: 0, expectedTotalBytes: 0));
      final cacheUri = p.join(settingStore.documentDir, 'cache', 'video');
      await Directory(cacheUri).create();
      try {
        final file = File(fileUrl);
        if (file.existsSync()) {
          downloadState = DownloadState.DONE;
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
          downloadState = DownloadState.PENDING;
        else
          downloadState = DownloadState.ERROR;
      } catch (e) {
        downloadState = DownloadState.ERROR;
      }
      downloadState = DownloadState.DONE;
    }
  }

  void dispose() {
    _cancelToken.cancel();
  }
}
