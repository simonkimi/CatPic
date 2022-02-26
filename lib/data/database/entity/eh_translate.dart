import 'package:drift/drift.dart';

// Eh翻译记录
class EhTranslateTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get namespace => text()();

  TextColumn get name => text()();

  TextColumn get translate => text()();

  TextColumn get link => text()();
}
