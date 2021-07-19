import 'package:moor/moor.dart';

// EHGallery的缓存记录
class GalleryCacheTable extends Table {
  TextColumn get gid => text()();

  TextColumn get token => text()();

  IntColumn get cacheTime =>
      integer().clientDefault(() => DateTime.now().millisecond)();

  // GalleryModel, 不要读取PreviewImage, 不准!
  BlobColumn get data => blob()();

  @override
  Set<Column> get primaryKey => {gid, token};
}
