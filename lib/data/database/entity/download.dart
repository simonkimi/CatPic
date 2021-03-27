import 'package:moor/moor.dart';


class DownloadTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get postId => text()();

  TextColumn get md5 => text()();

  IntColumn get websiteId => integer()();

  TextColumn get imgUrl => text()();

  TextColumn get largerUrl => text()();

  IntColumn get quality => integer()();

  BoolColumn get isFinish => boolean()();
}
