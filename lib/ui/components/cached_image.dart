import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

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

class CachedDioImage extends StatelessWidget {
  final ImageWidgetBuilder imageBuilder;
  final LoadingWidgetBuilder loadingBuilder;
  final ErrorBuilder errorBuilder;
  final String cachedKey;
  final double width;
  final double height;
  final String imgUrl;
  final Dio dio;
  final Duration duration;

  const CachedDioImage({
    Key key,
    @required this.imgUrl,
    @required this.imageBuilder,
    @required this.loadingBuilder,
    @required this.errorBuilder,
    this.cachedKey,
    this.width,
    this.height,
    this.dio,
    this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CachedDioImageState c = Get.put(CachedDioImageState(
      cachedKey: cachedKey ?? imgUrl,
      imgUrl: imgUrl,
      dio: dio,
    ));


    return Obx(() {
      return AnimatedSwitcher(
        duration: this.duration ?? Duration(seconds: 1),
        child: buildBody(context, c),
      );
    });
  }

  Widget buildBody(BuildContext context, CachedDioImageState c) {
    if (c.loadingType.value == LoadingType.DONE) {
      return imageBuilder(context, MemoryImage(c.data.value));
    } else if (c.loadingType.value == LoadingType.LOADING) {
      return loadingBuilder(
          context, c.totalSize.value, c.receivedSize.value, c.progress.value);
    } else {
      return errorBuilder(context, c.err);
    }
  }
}

class CachedDioImageState extends GetxController {
  var progress = 0.0.obs;
  var totalSize = 0.obs;
  var receivedSize = 0.obs;

  var data = Uint8List(0).obs;
  var loadingType = Rx<LoadingType>(LoadingType.LOADING);
  var err = Exception().obs;

  Dio dio;
  final String cachedKey;
  final String imgUrl;

  CachedDioImageState({
    this.dio,
    @required this.imgUrl,
    @required this.cachedKey,
  }) {
    this.dio ??= Dio();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var cached = await getCached();
      if (cached != null) {
        data.value = cached;
        loadingType.value = LoadingType.DONE;
      } else {
        var rsp = await dio.get<List<int>>(imgUrl,
            options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (received, total) {
          receivedSize.value = received;
          totalSize.value = total;
          progress.value =
              total != -1 ? receivedSize.value / totalSize.value : 0;
        });
        data.value = Uint8List.fromList(rsp.data);
        setCached(data.value);
        loadingType.value = LoadingType.DONE;
      }
    } catch (e) {
      loadingType.value = LoadingType.ERROR;
      err.value = e;
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
