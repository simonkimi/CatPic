import 'package:moor/moor.dart';

class GalleryCacheTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get gid => text()();

  TextColumn get token => text()();

  IntColumn get cacheTime =>
      integer().clientDefault(() => DateTime.now().millisecond)();

  BlobColumn get data => blob()();
}
