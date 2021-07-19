import 'package:catpic/ui/pages/eh_page/read_page/eh_image_viewer/store/store.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/data/models/gen/eh_download.pb.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:catpic/data/bridge/file_helper.dart' as fh;
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';

part 'loader_store.g.dart';

class DownloadLoaderStore = DownloadLoaderStoreBase with _$DownloadLoaderStore;

abstract class DownloadLoaderStoreBase with Store {
  DownloadLoaderStoreBase({
    required this.galleryModel,
    required this.imageCount,
  }) : pageLoadLock = List.filled((imageCount / 40).ceil(), Lock()) {
    store = EhReadStore(
      imageCount: imageCount,
      requestLoad: requestLoad,
      currentIndex: 0,
    );
  }

  final GalleryModel galleryModel;
  final int imageCount;
  late final EhReadStore store;

  // 是否加载基础数据, (下载默认不加载基础数据, 只有翻页到对应页面后, 才会尝试加载基础数据)
  var isLoadBase = false;

  // 下载里已经缓存的galleryID
  final Map<int, String> parsedGallery = {};

  // 加载页面时的锁
  final List<Lock> pageLoadLock;

  Future<void> loadImageFromDisk() async {
    final existPath = (await fh.walk('Gallery'))
        .where((e) => e.startsWith('${galleryModel.gid}-'))
        .toList();
    if (existPath.isNotEmpty) {
      final basePath = existPath[0];
      // 解析图片的galleryId数据
      final catpic = EhDownloadModel.fromBuffer(
          await fh.readFile(basePath, '.catpic') ?? []);
      parsedGallery.addEntries(catpic.pageInfo.entries);
    }
  }

  Future<void> loadPage(int index) async {}

  Future<void> requestLoad(int index) async {}
}
