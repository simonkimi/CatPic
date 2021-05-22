import 'package:moor/moor.dart';

class EhTranslateTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get namespace => text()();

  TextColumn get translate => text()();

  TextColumn get link => text()();
}
