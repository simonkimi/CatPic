import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';

import 'package:catpic/main.dart';

typedef ImageWidgetBuilder = Widget Function(
  BuildContext context,
  Uint8List imgData,
);

typedef LoadingWidgetBuilder = Widget Function(
    BuildContext context, ImageChunkEvent chunkEvent);

typedef ErrorBuilder = Widget Function(
    BuildContext context, Object? err, Function reload);

class DioImage extends StatefulWidget {
  const DioImage({
    Key? key,
    this.dio,
    required this.imageUrl,
    this.duration,
    required this.imageBuilder,
    required this.loadingBuilder,
    required this.errorBuilder,
  }) : super(key: key);

  final Dio? dio;
  final String imageUrl;
  final Duration? duration;

  final ImageWidgetBuilder imageBuilder;
  final LoadingWidgetBuilder loadingBuilder;
  final ErrorBuilder errorBuilder;

  @override
  _DioImageState createState() => _DioImageState();
}

enum LoadingType {
  DONE,
  LOADING,
  ERROR,
}

class _DioImageState extends State<DioImage> {
  late final Dio dio = widget.dio ?? Dio();
  var _loadingType = LoadingType.LOADING;

  var chunkEvent =
      const ImageChunkEvent(expectedTotalBytes: 0, cumulativeBytesLoaded: 0);
  final cancelToken = CancelToken();

  Uint8List? imageData;
  Object? err;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _loadingType = LoadingType.LOADING;
      chunkEvent = const ImageChunkEvent(
          expectedTotalBytes: null, cumulativeBytesLoaded: 0);
    });
    try {
      final rsp = await dio.get<List<int>>(widget.imageUrl,
          cancelToken: cancelToken,
          options: settingStore.dioCacheOptions
              .copyWith(policy: CachePolicy.request)
              .toOptions()
              .copyWith(responseType: ResponseType.bytes),
          onReceiveProgress: (received, total) {
        if (mounted) {
          setState(() {
            chunkEvent = ImageChunkEvent(
                expectedTotalBytes: total, cumulativeBytesLoaded: received);
          });
        }
      });
      if (mounted) {
        setState(() {
          imageData = Uint8List.fromList(rsp.data!);
          _loadingType = LoadingType.DONE;
        });
      }
    } on DioError catch(e) {
      if (mounted && !CancelToken.isCancel(e)) {
        setState(() {
          _loadingType = LoadingType.ERROR;
          err = e;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingType = LoadingType.ERROR;
          err = e;
        });
      }
    }
  }

  Widget buildBody(BuildContext context) {
    if (_loadingType == LoadingType.DONE) {
      return widget.imageBuilder(context, imageData!);
    } else if (_loadingType == LoadingType.LOADING) {
      return widget.loadingBuilder(context, chunkEvent);
    } else {
      return widget.errorBuilder(context, err, fetchData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration ?? const Duration(milliseconds: 500),
      child: buildBody(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
    cancelToken.cancel();
  }
}