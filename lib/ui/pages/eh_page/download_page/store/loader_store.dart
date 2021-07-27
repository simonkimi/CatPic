import 'dart:async';

import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/store/store.dart';
import 'package:catpic/utils/async.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/models/gen/eh_download.pb.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:catpic/data/bridge/file_helper.dart' as fh;
import 'package:synchronized/synchronized.dart';
import 'package:catpic/data/models/gen/eh_gallery_img.pb.dart';
import 'package:catpic/utils/utils.dart';

part 'loader_store.g.dart';

class DownloadLoaderStore = DownloadLoaderStoreBase with _$DownloadLoaderStore;

abstract class DownloadLoaderStoreBase with Store {
  DownloadLoaderStoreBase({
    required this.gid,
    required this.gtoken,
    required this.imageCount,
    required this.adapter,
  }) : pageLoader = List.generate(
            (imageCount / 40).ceil(),
            (index) => AsyncLoader(() => adapter.gallery(
                  gid: gid,
                  gtoken: gtoken,
                  page: index,
                ))) {
    store = EhReadStore<GalleryImgModel>(
      imageCount: imageCount,
      requestLoad: requestLoad,
      currentIndex: 0,
    );
  }

  final int imageCount;
  final EHAdapter adapter;
  final String gid;
  final String gtoken;
  late final EhReadStore<GalleryImgModel> store;

  // 下载里已经缓存的galleryID
  final Map<int, String> parsedGallery = {};
  late String basePath;

  // 加载页面结果
  final List<AsyncLoader<GalleryModel>> pageLoader;

  Future<void> loadImageFromDisk() async {
    final existPath =
        (await fh.walk('Gallery')).where((e) => e.startsWith('$gid-')).toList();
    if (existPath.isNotEmpty) {
      basePath = existPath[0];
      // 解析图片的galleryId数据
      final catpic = EhDownloadModel.fromBuffer(
          await fh.readFile(basePath, '.catpic') ?? []);
      parsedGallery.addEntries(catpic.pageInfo.entries);
      // 将已经解析了id的, 直接加入数据库
      for (final shaE in catpic.pageInfo.entries) {
        loadModel(page: shaE.key, shaToken: shaE.value);
      }
    }
  }

  void loadModel({
    required int page,
    required String shaToken,
  }) {
    final entity = store.readImageList[page - 1];
    if (entity.state.value == LoadingState.NONE) {
      entity.imageProvider = DioImageProvider(
          dio: adapter.dio,
          fileParams: FileParams(
            basePath: basePath,
            fileNameStart: page.format(9),
          ),
          builder: () async {
            final galleryImage = await adapter.galleryImage(
              gid: gid,
              shaToken: shaToken,
              page: page,
            );
            entity.extra = galleryImage;
            return DioImageParams(
              url: galleryImage.imgUrl,
              cacheKey: galleryImage.sha,
            );
          });
      entity.state.value = LoadingState.LOADED;
    }
  }

  Future<void> requestLoad(int index, bool isAuto) async {
    final baseLoader = pageLoader[0];
    if (baseLoader.hasError() && !isAuto) {
      baseLoader.reset();
    }
    final baseModel = await baseLoader.load();

    final page = (index / baseModel.imageCountInOnePage).floor();
    final loader = pageLoader[page];

    if (loader.hasError() && !isAuto) {
      loader.reset();
    }

    final model = await loader.load();
    for (final img in model.previewImages) {
      if (!parsedGallery.containsKey(img.page - 1)) {
        parsedGallery[img.page - 1] = img.shaToken;
        loadModel(page: img.page, shaToken: img.shaToken);
      }
    }
  }
}

class ReadPage<T> {
  T? pageItem;
  final lock = Lock();
}
