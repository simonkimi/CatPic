import 'package:moor/moor.dart';

// EH每张图片的Cache
class EhImageCache extends Table {
  TextColumn get shaToken => text()();

  TextColumn get gid => text()();

  // GalleryImgModel
  BlobColumn get pb => blob()();

  IntColumn get lastViewTime =>
      integer().clientDefault(() => DateTime.now().millisecond)();

  @override
  Set<Column> get primaryKey => {shaToken, gid};
}
