import 'package:moor/moor.dart';

class GalleryCacheTable extends Table {
  TextColumn get gid => text()();

  TextColumn get token => text()();

  IntColumn get page => integer()();

  IntColumn get cacheTime =>
      integer().clientDefault(() => DateTime.now().millisecond)();

  BlobColumn get data => blob()();

  @override
  Set<Column> get primaryKey => {gid, token, page};
}
