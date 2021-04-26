import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';

import 'package:catpic/data/database/dao/download_dao.dart';
import 'package:catpic/data/database/dao/history_dao.dart';
import 'package:catpic/data/database/dao/tag_dao.dart';
import 'package:catpic/data/database/dao/host_dao.dart';
import 'package:catpic/data/database/dao/website_dao.dart';

import 'entity/download.dart';
import 'entity/history.dart';
import 'entity/host.dart';
import 'entity/tag.dart';
import 'entity/website.dart';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(
    tables: [DownloadTable, HistoryTable, HostTable, TagTable, WebsiteTable],
    daos: [DownloadDao, HistoryDao, HostDao, TagDao, WebsiteDao])
class AppDataBase extends _$AppDataBase {
  AppDataBase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

class DatabaseHelper {
  factory DatabaseHelper() => _databaseHelper;

  DatabaseHelper._();

  static final DatabaseHelper _databaseHelper = DatabaseHelper._();
  final AppDataBase _database = AppDataBase();

  WebsiteDao get websiteDao => _database.websiteDao;

  HostDao get hostDao => _database.hostDao;

  TagDao get tagDao => _database.tagDao;

  HistoryDao get historyDao => _database.historyDao;

  DownloadDao get downloadDao => _database.downloadDao;
}
