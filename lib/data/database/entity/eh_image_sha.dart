import 'package:moor/moor.dart';

class EhDownloadShaTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get sha => text()();

  TextColumn get gid => text()();

  IntColumn get index => integer()();
}
