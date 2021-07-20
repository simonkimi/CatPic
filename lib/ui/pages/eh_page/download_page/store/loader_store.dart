import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/store/store.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/models/gen/eh_download.pb.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:catpic/data/bridge/file_helper.dart' as fh;
import 'package:synchronized/synchronized.dart';

part 'loader_store.g.dart';

class DownloadLoaderStore = DownloadLoaderStoreBase with _$DownloadLoaderStore;

abstract class DownloadLoaderStoreBase with Store {
  DownloadLoaderStoreBase({
    required this.gid,
    required this.gtoken,
    required this.imageCount,
    required this.adapter,
    required this.imageCountInOnePage,
  }) : pageLoadLock = List.filled((imageCount / 40).ceil(), Lock()) {
    store = EhReadStore(
      imageCount: imageCount,
      requestLoad: requestLoad,
      currentIndex: 0,
    );
  }

  final int imageCount;
  late final EhReadStore store;
  final EHAdapter adapter;
  final String gid;
  final String gtoken;

  // 加载基础数据, (下载默认不加载基础数据, 只有翻页到对应页面后, 才会尝试加载基础数据)
  GalleryModel? galleryModel;
  Exception? lastBaseException;
  final baseModeLock = Lock();
  int imageCountInOnePage;

  // 下载里已经缓存的galleryID
  final Map<int, String> parsedGallery = {};
  late String basePath;

  // 加载页面时的锁
  final List<Lock> pageLoadLock;

  Future<void> loadImageFromDisk() async {
    final existPath =
        (await fh.walk('Gallery')).where((e) => e.startsWith('$gid-')).toList();
    if (existPath.isNotEmpty) {
      basePath = existPath[0];
      // 解析图片的galleryId数据
      final catpic = EhDownloadModel.fromBuffer(
          await fh.readFile(basePath, '.catpic') ?? []);
      parsedGallery.addEntries(catpic.pageInfo.entries);
    }
  }

  Future<GalleryModel> loadBaseModel() async {
    return await baseModeLock.synchronized<GalleryModel>(() async {
      if (galleryModel != null) return galleryModel!;
      if (lastBaseException != null) throw lastBaseException!;
      galleryModel = await adapter.gallery(gid: gid, gtoken: gtoken, page: 0);
      return galleryModel!;
    });
  }

  Future<void> loadPage(int pageIndex) async {
    final galleryModel = await adapter.gallery(
      gid: gid,
      gtoken: gtoken,
      page: pageIndex,
    );
    await loadImageModel(galleryModel.previewImages);
  }

  Future<void> requestLoad(int index, bool isAuto) async {
    if (!isAuto) lastBaseException = null;
    final model = await loadBaseModel();
    await loadPage((index / model.imageCountInOnePage).floor());
  }

  Future<void> loadImageModel(List<GalleryPreviewImageModel> images) async {}
}
