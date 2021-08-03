import 'package:catpic/data/database/database.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/store/store.dart';
import 'package:catpic/data/models/gen/eh_preview.pb.dart';
import 'package:catpic/utils/async.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:catpic/data/bridge/file_helper.dart' as fh;
import 'package:dio/dio.dart' hide Lock;
import 'package:mobx/mobx.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:catpic/data/models/gen/eh_download.pb.dart';
import 'package:catpic/utils/utils.dart';
import 'package:catpic/data/models/gen/eh_storage.pb.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';

import '../../../../../main.dart';

part 'store.g.dart';

class EhGalleryStore = EhGalleryStoreBase with _$EhGalleryStore;

// 主要存放数据是Gallery下面小图片的数据
abstract class EhGalleryStoreBase extends ILoadMore<GalleryPreviewImageModel>
    with Store {

  EhGalleryStoreBase({
    required this.gid,
    required this.gtoken,
    required this.adapter,
    this.previewModel,
    this.previewAspectRatio,
    required this.disposeToken,
  })  :
        pageLoader = [
          AsyncLoader(() => adapter.gallery(
                gid: gid,
                gtoken: gtoken,
                page: 0,
                cancelToken: disposeToken,
              ))
        ],
        super('');

  final String gid;
  final String gtoken;
  final EHAdapter adapter;
  late String basePath;

  @observable
  PreViewItemModel? previewModel;
  @observable
  GalleryModel? galleryModel;
  @observable
  double? previewAspectRatio;

  // 存放普通图片数据, URL相同的公用一个Provider
  final normalImageMap = <String, DioImageProvider>{};

  // 下载里已经缓存的galleryToken, 后期解析的也会添加到这里来
  final Map<int, String> parsedGallery = {};
  final Map<int, String> downloadedFileName = {};
  bool isDownload = false;

  // 阅读的Store
  late EhReadStore readStore;

  // 加载页面的加载器
  late final List<AsyncLoader<GalleryModel>> pageLoader;
  final baseLock = Lock();

  // 收藏
  @observable
  int favcat = -1;
  @observable
  bool isFavLoading = false;
  @observable
  bool isDownloadLoading = false;

  final CancelToken disposeToken;

  @override
  Future<List<GalleryPreviewImageModel>> loadPage(int page) async {
    final ehPage = page - 1;
    if (galleryModel == null) await loadBaseModel();

    late final GalleryModel model;
    if (ehPage == 0) {
      model = galleryModel!;
    } else {
      final loader = pageLoader[ehPage];
      model = await loader.load();
    }

    for (final img in model.previewImages) {
      if (!parsedGallery.containsKey(img.page - 1)) {
        parsedGallery[img.page - 1] = img.shaToken;
        loadReadModel(index: img.page - 1, shaToken: img.shaToken);
      }
      // 缩略图解析
      if (!img.isLarge && !normalImageMap.containsKey(img.imageUrl)) {
        normalImageMap[img.imageUrl] = DioImageProvider(
          url: img.imageUrl,
          dio: adapter.dio,
        );
      }
    }
    return model.previewImages;
  }

  // 加载基础数据
  @action
  Future<GalleryModel> loadBaseModel() async {
    return await baseLock.synchronized(() async {
      try {
        final baseLoader = pageLoader[0];
        if (baseLoader.hasError()) {
          baseLoader.reset();
        }
        var baseModel = adapter.cache.get<GalleryModel>('$gid-$gtoken');
        if (baseModel == null) {
          baseModel ??= await baseLoader.load();
          adapter.cache.set('$gid-$gtoken', baseModel);
        }
        if (galleryModel != null) return baseModel;
        galleryModel ??= baseModel;
        final page =
            (baseModel.imageCount / baseModel.imageCountInOnePage).ceil();

        readStore = EhReadStore(
          gid: gid,
          gtoken: gtoken,
          imageCount: baseModel.imageCount,
          requestLoad: requestLoadReadImage,
          currentIndex: 0,
        );

        // 加载下载数据
        if (await fh.hasDownloadPermission()) {
          final model = await DB().ehDownloadDao.getByGid(gid, gtoken);
          if (model != null) {
            isDownload = true;
            await loadImageFromDisk();
          }
        }
        pageLoader.addAll(List.generate(
            page - 1,
            (index) => AsyncLoader(() => adapter.gallery(
                gid: gid,
                gtoken: gtoken,
                page: index + 1,
                cancelToken: disposeToken))));

        favcat = baseModel.favcat;
        previewModel ??= PreViewItemModel(
          gtoken: gtoken,
          gid: gid,
          title: baseModel.title,
          tag: baseModel.tag,
          keyTags: [],
          previewImg: baseModel.previewImage,
          stars: baseModel.star,
          language: baseModel.language,
          pages: baseModel.imageCount,
          uploader: baseModel.uploader,
          uploadTime: baseModel.uploadTime,
          previewWidth: baseModel.previewWidth,
          previewHeight: baseModel.previewHeight,
        );

        previewAspectRatio ??= baseModel.previewWidth / baseModel.previewHeight;

        return baseModel;
      } catch (e) {
        lastException = e.toString();
        rethrow;
      }
    });
  }

  // 如果是已经下载了的, 则尝试从下载里拿数据
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
                cancelToken: disposeToken,
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
      }
    }
  }

  // 阅读里, 需要加载页面
  Future<void> requestLoadReadImage(int index, bool isAuto) async {
    // 解析大图
    final needParseGallery = !parsedGallery.containsKey(index);
    final needParsedPreview =
        readStore.previewImageList[index].state.value == LoadingState.NONE;

    if (needParseGallery || needParsedPreview) {
      final baseModel = await loadBaseModel();
      final page = (index / baseModel.imageCountInOnePage).floor();
      final loader = pageLoader[page];
      if (loader.locked) return;
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

  void loadReadModel({
    required int index,
    required String shaToken,
  }) {
    final entity = readStore.readImageList[index];
    if (entity.state.value == LoadingState.NONE) {
      entity.imageProvider = DioImageProvider(
          dio: adapter.dio,
          fileParams: isDownload
              ? FileParams(
                  basePath: basePath,
                  fileName: downloadedFileName[index] ?? (index + 1).format(9),
                )
              : null,
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

  void dispose() {
    disposeToken.cancel();
    for (final e in readStore.readImageList) {
      e.dispose();
    }
    for (final e in readStore.previewImageList) {
      e.dispose();
    }
  }

  @action
  Future<bool> onFavouriteClick(int favcat) async {
    isFavLoading = true;
    try {
      final result = await adapter.addToFavourite(
          gid: gid, gtoken: gtoken, favcat: favcat);
      if (result) {
        this.favcat = favcat;
        DB().galleryCacheDao.updateFavcat(gid, gtoken, favcat);
        final model = adapter.cache.get<GalleryModel>('$gid-$gtoken');
        if (model != null) {
          model.favcat = favcat;
          adapter.cache.set('$gid-$gtoken', model);
        }
      }
      return result;
    } finally {
      isFavLoading = false;
    }
  }

  @action
  Future<bool> onDownloadClick() async {
    isDownloadLoading = true;
    try {
      if (await fh.hasDownloadPermission()) {
        final result = await ehDownloadStore.createDownloadTask(
          gid,
          gtoken,
          adapter.website.id,
        );
        return result;
      } else {
        fh.requestDownloadPath(I18n.context);
        return false;
      }
    } finally {
      isDownloadLoading = false;
    }
  }

  void refresh() {
    normalImageMap.clear();
    galleryModel = null;
    previewModel = null;
    adapter.cache.set('$gid-$gtoken', null);
    parsedGallery.clear();
    for (final page in pageLoader) {
      page.reset();
    }
    onRefresh();
  }

  EHStorage get storage =>
      EHStorage.fromBuffer(adapter.websiteEntity.storage ?? []);

  @override
  @observable
  bool isLoading = true;

  @override
  @observable
  String? lastException;

  @override
  @action
  Future<void> onDataChange() async {}

  @override
  bool isItemExist(GalleryPreviewImageModel item) => false;

  @override
  int? get pageItemCount => null;

  @computed
  bool get isLoaded => galleryModel != null;
}
