import 'package:moor/moor.dart';


class DownloadStatus {
  static const PENDING = 0;
  static const FINISH = 1;
  static const UNREACHABLE = 2;
  static const FAIL = 3;
}


class DownloadTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get fileName => text()();

  TextColumn get postId => text()();

  TextColumn get md5 => text()();

  IntColumn get websiteId => integer()();

  TextColumn get imgUrl => text()();

  TextColumn get previewUrl => text()();

  TextColumn get largerUrl => text()();

  IntColumn get quality => integer()();

  IntColumn get status => integer()();

  TextColumn get booruJson => text()();
  
  DateTimeColumn get createTime => dateTime().clientDefault(() => DateTime.now())();
}
