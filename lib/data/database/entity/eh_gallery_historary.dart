import 'package:drift/drift.dart';

// EH历史记录数据库
class EhGalleryHistoryTable extends Table {
  TextColumn get gid => text()();

  TextColumn get gtoken => text()();

  IntColumn get lastViewTime =>
      integer().clientDefault(() => DateTime.now().millisecond)();

  /// [PreViewItemModel]
  BlobColumn get pb => blob()();

  @override
  Set<Column> get primaryKey => {gid, gtoken};
}
