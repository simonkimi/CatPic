import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/store/store.dart';
import 'package:catpic/data/models/gen/eh_preview.pb.dart';
import 'package:catpic/utils/async.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:catpic/data/bridge/file_helper.dart' as fh;
import 'package:mobx/mobx.dart';
import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:catpic/data/models/gen/eh_gallery_img.pb.dart';
import 'package:catpic/data/models/gen/eh_download.pb.dart';
import 'package:catpic/utils/utils.dart';
import 'package:catpic/data/models/gen/eh_storage.pb.dart';
import 'package:get/get.dart';

part 'store.g.dart';

class EhGalleryStore = EhGalleryStoreBase with _$EhGalleryStore;

// 主要存放数据是Gallery下面小图片的数据
abstract class EhGalleryStoreBase extends ILoadMore<GalleryPreviewImageModel>
    with Store {
  EhGalleryStoreBase({
    required this.gid,
    required this.gtoken,
    required this.adapter,
    required this.isDownload,
    this.previewModel,
  })  : pageLoader = [
          AsyncLoader(() => adapter.gallery(
                gid: gid,
                gtoken: gtoken,
                page: 0,
              ))
        ],
        super('') {
    if (isDownload) {
      loadImageFromDisk();
    }
  }

  final String gid;
  final String gtoken;
  final EHAdapter adapter;
  final bool isDownload;
  late String basePath;

  PreViewItemModel? previewModel;
  GalleryModel? galleryModel;

  // 存放普通图片数据, URL相同的公用一个Provider
  final normalImageMap = <String, DioImageProvider>{};

  // 下载里已经缓存的galleryToken, 后期解析的也会添加到这里来
  final Map<int, String> parsedGallery = {};
  final Map<int, String> downloadedFileName = {};

  // 阅读的Store
  late final EhReadStore<GalleryImgModel> readStore;

  // 加载页面的加载器
  final List<AsyncLoader<GalleryModel>> pageLoader;

  // 收藏
  @observable
  int favcat = -1;

  @override
  Future<List<GalleryPreviewImageModel>> loadPage(int page) async {
    final ehPage = page - 1;
    final loader = pageLoader[ehPage];
    final galleryModel = await loader.load();
    for (final img in galleryModel.previewImages) {
      // 图片地址解析
      if (!parsedGallery.containsKey(ehPage)) {
        parsedGallery[ehPage] = img.shaToken;
        loadReadModel(page: ehPage, shaToken: img.shaToken);
      }
      // 缩略图解析
      if (!img.isLarge && !normalImageMap.containsKey(img.imageUrl)) {
        normalImageMap[img.imageUrl] = DioImageProvider(
          url: img.imageUrl,
          dio: adapter.dio,
        );
      }
    }

    return galleryModel.previewImages;
  }

  // 加载基础数据
  Future<GalleryModel> loadBaseModel() async {
    try {
      final baseLoader = pageLoader[0];
      if (baseLoader.hasError()) {
        baseLoader.reset();
      }
      final baseModel = await baseLoader.load();
      if (galleryModel != null) return baseModel;
      galleryModel ??= baseModel;
      final page =
          (baseModel.imageCount / baseModel.imageCountInOnePage).ceil();
      pageLoader.addAll(List.generate(
          page - 1,
          (index) => AsyncLoader(() => adapter.gallery(
                gid: gid,
                gtoken: gtoken,
                page: index + 1,
              ))));

      readStore = EhReadStore<GalleryImgModel>(
        imageCount: baseModel.imageCount,
        requestLoad: requestLoadReadImage,
        currentIndex: 0,
      );

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

      return baseModel;
    } catch (e) {
      lastException = e.toString();
      rethrow;
    }
  }

  // 如果是已经下载了的, 则尝试从下载里拿数据
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
        loadReadModel(page: shaE.key, shaToken: shaE.value);
      }
      // 下载好了的图片
      final files = await fh.walk(basePath);
      downloadedFileName.addEntries(files
          .map((e) => e.split('.'))
          .where((e) =>
              e.length == 2 && e[0].isNum && (e[1] == 'jpg' || e[1] == 'png'))
          .map((e) => MapEntry(e[0].toInt(), e.join('.'))));
    }
  }

  // 阅读里, 需要加载页面
  Future<void> requestLoadReadImage(int index, bool isAuto) async {
    if (!parsedGallery.containsKey(index)) {
      // 如果坐标索引没有被解析的话
      final baseModel = await loadBaseModel();

      final page = (index / baseModel.imageCountInOnePage).floor();
      final loader = pageLoader[page];

      if (loader.hasError() && !isAuto) {
        loader.reset();
      }

      final model = await loader.load();
      for (final img in model.previewImages) {
        if (!parsedGallery.containsKey(img.page - 1)) {
          parsedGallery[img.page - 1] = img.shaToken;
          loadReadModel(page: img.page - 1, shaToken: img.shaToken);
        }
      }
    } else {
      // 如果此页面已经被解析了的话, 重新加载此页面
      final imgModel = readStore.readImageList[index];
      imgModel.imageProvider = null;
      imgModel.lastException = null;
      imgModel.state.value = LoadingState.NONE;
      loadReadModel(page: index, shaToken: parsedGallery[index]!);
    }
  }

  void loadReadModel({
    required int page,
    required String shaToken,
  }) {
    final entity = readStore.readImageList[page - 1];
    if (entity.state.value == LoadingState.NONE) {
      entity.imageProvider = DioImageProvider(
          dio: adapter.dio,
          fileParams: isDownload
              ? FileParams(
                  basePath: basePath,
                  fileName: downloadedFileName[page] ?? page.format(9),
                )
              : null,
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

  void dispose() {
    // TODO Dispose
  }

  Future<bool> onFavouriteClick(int favcat) async {
    final result =
        await adapter.addToFavourite(gid: gid, gtoken: gtoken, favcat: favcat);
    if (result) {
      this.favcat = favcat;
      DB().galleryCacheDao.updateFavcat(gid, gtoken, favcat);
    }
    return result;
  }

  EHStorage get storage => EHStorage.fromBuffer(adapter.website.storage ?? []);

  @override
  @observable
  bool isLoading = false;

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
}
