import 'package:drift/drift.dart';

class TagTable extends Table {
  IntColumn get website => integer()();

  TextColumn get tag => text()();

  @override
  Set<Column> get primaryKey => {tag};
}
