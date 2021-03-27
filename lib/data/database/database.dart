import 'package:catpic/data/database/dao/download_dao.dart';
import 'package:catpic/data/database/dao/history_dao.dart';
import 'package:catpic/data/database/dao/tag_dao.dart';
import 'package:catpic/data/database/dao/host_dao.dart';
import 'package:catpic/data/database/dao/website_dao.dart';
import 'package:moor/moor.dart';

import 'entity/download.dart';
import 'entity/history.dart';
import 'entity/host.dart';
import 'entity/tag.dart';
import 'entity/website.dart';

part 'database.g.dart';

@UseMoor(
    tables: [DownloadTable, HistoryTable, HostTable, TagTable, WebsiteTable],
    daos: [DownloadDao, HistoryDao, HostDao, TagDao, WebsiteDao])
class AppDataBase extends _$AppDataBase {
  AppDataBase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}
