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
import 'package:catpic/utils/utils.dart';
import 'package:get/get.dart';

part 'loader_store.g.dart';

class DownloadLoaderStore = DownloadLoaderStoreBase with _$DownloadLoaderStore;

abstract class DownloadLoaderStoreBase with Store {
  DownloadLoaderStoreBase({
    required this.gid,
    required this.gtoken,
    required this.imageCount,
    required this.adapter,
    required this.model,
  }) : pageLoader = List.generate(
            (imageCount / 40).ceil(),
            (index) => AsyncLoader(() => adapter.gallery(
                  gid: gid,
                  gtoken: gtoken,
                  page: index,
                ))) {
    readStore = EhReadStore(
      gid: gid,
      gtoken: gtoken,
      imageCount: imageCount,
      requestLoad: requestLoad,
      currentIndex: 0,
    );
    loadImageFromDisk();
  }

  final int imageCount;
  final EHAdapter adapter;
  final String gid;
  final String gtoken;
  late final EhReadStore readStore;
  final GalleryModel model;

  // 下载里已经缓存的galleryID
  final Map<int, String> parsedGallery = {};
  final Map<int, String> downloadedFileName = {};
  late String basePath;

  // 加载页面结果
  final List<AsyncLoader<GalleryModel>> pageLoader;

  // 存放普通图片数据, URL相同的公用一个Provider
  final normalImageMap = <String, DioImageProvider>{};

  Future<void> loadImageFromDisk() async {
    final existPath =
        (await fh.walk('Gallery')).where((e) => e.startsWith('$gid-')).toList();
    if (existPath.isNotEmpty) {
      basePath = 'Gallery/${existPath[0]}';
      // 解析图片的galleryId数据
      final catpic = EhDownloadModel.fromBuffer(
          await fh.readFile(basePath, '.catpic') ?? []);
      parsedGallery.addEntries(catpic.pageInfo.entries);
      // 下载好了的图片
      final files = await fh.walk(basePath);
      downloadedFileName.addEntries(files
          .map((e) => e.split('.'))
          .where((e) =>
              e.length == 2 && e[0].isNum && (e[1] == 'jpg' || e[1] == 'png'))
          .map((e) => MapEntry(e[0].toInt() - 1, e.join('.'))));
      // 将已经解析了id的, 直接加入数据库
      for (final shaE in catpic.pageInfo.entries) {
        loadReadModel(index: shaE.key, shaToken: shaE.value);
      }
      // 将已经下载的图片, 直接加入预览库
      for (final downloaded in downloadedFileName.entries) {
        final entity = readStore.previewImageList[downloaded.key];
        entity.imageProvider = DioImageProvider(
            dio: adapter.dio,
            builder: () async {
              final galleryImage = await adapter.galleryImage(
                gid: gid,
                shaToken: parsedGallery[downloaded.key]!,
                page: downloaded.key,
              );
              return DioImageParams(
                url: galleryImage.imgUrl,
                cacheKey: galleryImage.sha,
              );
            },
            fileParams: FileParams(
              basePath: basePath,
              fileName: downloaded.value,
            ));
        entity.state.value = LoadingState.LOADED;
        entity.extra = GalleryPreviewImageModel(
          isLarge: true
        );
      }
    } else {
      // 没有这个文件夹, 可能被删了
      basePath =
          'Gallery/$gid-${model.title.safFileName}';
      await fh.createDir(basePath);
    }
  }

  void loadReadModel({
    required int index,
    required String shaToken,
  }) {
    final entity = readStore.readImageList[index];
    if (entity.state.value == LoadingState.NONE) {
      entity.imageProvider = DioImageProvider(
          dio: adapter.dio,
          fileParams: FileParams(
            basePath: basePath,
            fileName: downloadedFileName[index] ?? (index + 1).format(9),
          ),
          builder: () async {
            final galleryImage = await adapter.galleryImage(
              gid: gid,
              shaToken: shaToken,
              page: index + 1,
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
    final needParseGallery = !parsedGallery.containsKey(index);
    final needParsedPreview =
        readStore.previewImageList[index].state.value == LoadingState.NONE;

    if (needParseGallery || needParsedPreview) {
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

      // 大图数据
      final model = await loader.load();
      for (final img in model.previewImages) {
        if (!parsedGallery.containsKey(img.page - 1)) {
          parsedGallery[img.page - 1] = img.shaToken;
          loadReadModel(index: img.page - 1, shaToken: img.shaToken);
        }
      }

      // 预览数据
      for (final img in model.previewImages) {
        loadPreviewModel(index: img.page - 1, img: img);
      }
    }
  }

  void loadPreviewModel({
    required int index,
    required GalleryPreviewImageModel img,
  }) {
    final entity = readStore.previewImageList[img.page - 1];
    if (entity.state.value == LoadingState.NONE) {
      if (img.isLarge) {
        // 如果是大图, 则直接把数据存进去
        entity.imageProvider = DioImageProvider(
          url: img.imageUrl,
          dio: adapter.dio,
        );
      } else {
        // 如果是普通, 则存入全局map
        if (!normalImageMap.containsKey(img.imageUrl)) {
          normalImageMap[img.imageUrl] = DioImageProvider(
            url: img.imageUrl,
            dio: adapter.dio,
          );
        }
        entity.imageProvider = normalImageMap[img.imageUrl];
      }
      entity.state.value = LoadingState.LOADED;
      entity.extra = img;
    }
  }
}

class ReadPage<T> {
  T? pageItem;
  final lock = Lock();
}
