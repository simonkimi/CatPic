import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

typedef ImageWidgetBuilder = Widget Function(
  BuildContext context,
  Uint8List imgData,
);

typedef LoadingWidgetBuilder = Widget Function(
    BuildContext context, ImageChunkEvent chunkEvent);

typedef ErrorBuilder = Widget Function(
    BuildContext context, Object err, Function reload);

enum LoadingType { DONE, LOADING, ERROR }

class CachedDioImage extends StatefulWidget {
  const CachedDioImage({
    Key key,
    this.dio,
    this.cachedKey,
    this.duration,
    this.useCached = true,
    @required this.imgUrl,
    @required this.imageBuilder,
    @required this.loadingBuilder,
    @required this.errorBuilder,
  }) : super(key: key);

  final ImageWidgetBuilder imageBuilder;
  final LoadingWidgetBuilder loadingBuilder;
  final ErrorBuilder errorBuilder;
  final String cachedKey;
  final String imgUrl;
  final Dio dio;
  final Duration duration;
  final bool useCached;

  @override
  _CachedDioImageState createState() => _CachedDioImageState();
}

class _CachedDioImageState extends State<CachedDioImage> {
  Dio _dio;
  Object err;
  int totalSize;
  int receivedSize;
  Uint8List data;
  LoadingType loadingType;
  String cachedKey;

  @override
  void initState() {
    super.initState();
    _dio = widget.dio ?? Dio();
    totalSize = 0;
    receivedSize = 0;
    loadingType = LoadingType.LOADING;
    cachedKey = widget.cachedKey ?? widget.imgUrl;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration ?? const Duration(milliseconds: 500),
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (loadingType == LoadingType.DONE) {
      return widget.imageBuilder(context, data);
    } else if (loadingType == LoadingType.LOADING) {
      return widget.loadingBuilder(
          context,
          ImageChunkEvent(
              cumulativeBytesLoaded: receivedSize,
              expectedTotalBytes: totalSize));
    } else {
      return widget.errorBuilder(context, err, reload);
    }
  }

  Future<void> reload() async {
    setState(() {
      loadingType = LoadingType.LOADING;
      err = null;
    });
    await fetchData();
  }

  Future<void> fetchData() async {
    try {
      if (widget.useCached) {
        final cached = await getCached();
        if (cached != null) {
          setState(() {
            data = cached;
            loadingType = LoadingType.DONE;
          });
          return;
        }
      }

      final rsp = await _dio.get<List<int>>(widget.imgUrl,
          options: Options(responseType: ResponseType.bytes),
          onReceiveProgress: (received, total) {
        if (mounted) {
          setState(() {
            receivedSize = received;
            totalSize = total;
          });
        }
      });

      if (mounted) {
        setState(() {
          data = Uint8List.fromList(rsp.data);
          setCached(data);
          loadingType = LoadingType.DONE;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loadingType = LoadingType.ERROR;
          err = e;
        });
      }
    }
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
}
