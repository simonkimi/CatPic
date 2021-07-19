import 'package:moor/moor.dart';

// EH阅读历史记录
class EhReadHistoryTable extends Table {
  TextColumn get gid => text()();

  TextColumn get gtoken => text()();

  IntColumn get readPage => integer()();
}
