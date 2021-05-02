import 'package:moor/moor.dart';

class HistoryType {
  static const POST = 0;
  static const POOL = 1;
  static const ARTIST = 2;
}

class HistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get history => text()();

  IntColumn get type => integer()();

  DateTimeColumn get createTime =>
      dateTime().clientDefault(() => DateTime.now())();
}
