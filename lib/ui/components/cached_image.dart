import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

typedef ImageWidgetBuilder = Widget Function(
  BuildContext context,
  ImageProvider imageProvider,
);

typedef LoadingWidgetBuilder = Widget Function(
  BuildContext context,
  int total,
  int received,
  double progress,
);

typedef ErrorBuilder = Widget Function(BuildContext context, Object err);

enum LoadingType { DONE, LOADING, ERROR }

class CachedDioImage extends StatefulWidget {
  final ImageWidgetBuilder imageBuilder;
  final LoadingWidgetBuilder loadingBuilder;
  final ErrorBuilder errorBuilder;
  final String cachedKey;
  final String imgUrl;
  final Dio dio;
  final Duration duration;

  const CachedDioImage({
    Key key,
    this.dio,
    this.cachedKey,
    this.duration,
    @required this.imgUrl,
    @required this.imageBuilder,
    @required this.loadingBuilder,
    @required this.errorBuilder,
  }) : super(key: key);

  @override
  _CachedDioImageState createState() => _CachedDioImageState();
}

class _CachedDioImageState extends State<CachedDioImage> {
  Dio _dio;
  Object err;
  double progress;
  int totalSize;
  int receivedSize;
  Uint8List data;
  LoadingType loadingType;
  String cachedKey;

  @override
  void initState() {
    super.initState();
    _dio = widget.dio ?? Dio();
    progress = 0;
    totalSize = 0;
    receivedSize = 0;
    loadingType = LoadingType.LOADING;
    cachedKey = widget.cachedKey ?? widget.imgUrl;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration ?? Duration(milliseconds: 500),
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (loadingType == LoadingType.DONE) {
      return widget.imageBuilder(context, MemoryImage(data));
    } else if (loadingType == LoadingType.LOADING) {
      return widget.loadingBuilder(context, totalSize, receivedSize, progress);
    } else {
      return widget.errorBuilder(context, err);
    }
  }

  Future<void> fetchData() async {
    try {
      var cached = await getCached();
      if (cached != null) {
        setState(() {
          data = cached;
          loadingType = LoadingType.DONE;
        });
      } else {
        var rsp = await _dio.get<List<int>>(widget.imgUrl,
            options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (received, total) {
          if (mounted) {
            setState(() {
              receivedSize = received;
              totalSize = total;
              progress = total != -1 ? receivedSize / totalSize : 0;
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
}
