import 'dart:typed_data';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

typedef ImageWidgetBuilder = Widget Function(
  BuildContext context,
  Uint8List imgData,
);

typedef LoadingWidgetBuilder = Widget Function(
    BuildContext context, ImageChunkEvent chunkEvent);

typedef ErrorBuilder = Widget Function(
    BuildContext context, Object? err, Function reload);

enum LoadingType { DONE, LOADING, ERROR }

class CachedDioImage extends StatefulWidget {
  const CachedDioImage({
    Key? key,
    this.dio,
    this.duration,
    required this.imgUrl,
    required this.imageBuilder,
    required this.loadingBuilder,
    required this.errorBuilder,
  }) : super(key: key);

  final ImageWidgetBuilder imageBuilder;
  final LoadingWidgetBuilder loadingBuilder;
  final ErrorBuilder errorBuilder;
  final String imgUrl;
  final Dio? dio;
  final Duration? duration;

  @override
  _CachedDioImageState createState() => _CachedDioImageState();
}

class _CachedDioImageState extends State<CachedDioImage> {
  late Dio _dio;
  late Object? err;
  late int totalSize;
  late int receivedSize;
  late Uint8List data;
  late LoadingType loadingType;

  final cancelToken = CancelToken();

  @override
  void initState() {
    super.initState();
    _dio = widget.dio ?? Dio();
    totalSize = 0;
    receivedSize = 0;
    loadingType = LoadingType.LOADING;
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    cancelToken.cancel();
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
      final rsp = await _dio.get<Uint8List>(widget.imgUrl,
          cancelToken: cancelToken,
          options: settingStore.dioCacheOptions
              .copyWith(policy: CachePolicy.request)
              .toOptions()
              .copyWith(responseType: ResponseType.bytes),
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
          data = rsp.data!;
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
}
