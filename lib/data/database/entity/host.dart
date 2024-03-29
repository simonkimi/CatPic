import 'package:drift/drift.dart';

class HostTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get host => text()();

  TextColumn get ip => text()();

  IntColumn get websiteId => integer()();
}
