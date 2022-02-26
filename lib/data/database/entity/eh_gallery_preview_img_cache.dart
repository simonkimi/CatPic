import 'package:drift/drift.dart';

// EHGallery下面小图片的记录
class EhGalleryPreviewImgCache extends Table {
  TextColumn get gid => text()();

  TextColumn get gtoken => text()();

  IntColumn get index => integer()();

  // GalleryPreviewImageModel
  BlobColumn get pb => blob()();

  IntColumn get cacheTime =>
      integer().clientDefault(() => DateTime.now().millisecond)();
}
