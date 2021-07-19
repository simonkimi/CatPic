import 'package:moor/moor.dart';

// EH历史记录数据库
class EhGalleryHistoryTable extends Table {
  TextColumn get gid => text()();

  TextColumn get gtoken => text()();

  IntColumn get lastViewTime =>
      integer().clientDefault(() => DateTime.now().millisecond)();

  BlobColumn get pb => blob()();

  @override
  Set<Column> get primaryKey => {gid, gtoken};
}
