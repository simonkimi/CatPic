import 'package:moor/moor.dart';


class HistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get history => text()();

  DateTimeColumn get createTime =>
      dateTime().clientDefault(() => DateTime.now())();
}
