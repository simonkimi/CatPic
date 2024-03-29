import 'package:drift/drift.dart';

class HistoryType {
  static const POST = 0;
  static const POOL = 1;
  static const ARTIST = 2;
  static const TAG = 3;
  static const EH = 4;
}

class HistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get history => text()();

  IntColumn get type => integer()();

  DateTimeColumn get createTime =>
      dateTime().clientDefault(() => DateTime.now())();
}
