import 'package:moor/moor.dart';

class EhReadHistoryTable extends Table {
  TextColumn get gid => text()();

  TextColumn get gtoken => text()();

  IntColumn get readPage => integer()();
}
