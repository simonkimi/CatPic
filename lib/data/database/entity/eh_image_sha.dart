import 'package:drift/drift.dart';

// EH下载图片的sha的记录
class EhDownloadShaTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get sha => text()();

  TextColumn get gid => text()();

  IntColumn get index => integer()();
}
