import 'package:moor/moor.dart';

import 'entity/download.dart';
import 'entity/history.dart';
import 'entity/host.dart';
import 'entity/tag.dart';
import 'entity/website.dart';

part 'database.g.dart';

@UseMoor(tables: [
  DownloadTable,
  HistoryTable,
  HostTable,
  TagTable,
  WebsiteTable
])
class AppDataBase extends _$AppDataBase {
  AppDataBase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}
