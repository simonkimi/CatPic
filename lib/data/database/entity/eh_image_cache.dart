import 'package:moor/moor.dart';

// EH每张图片的Cache
class EhImageCache extends Table {
  TextColumn get shaToken => text()();

  TextColumn get gid => text()();
}
