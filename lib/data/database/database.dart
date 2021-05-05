import 'dart:ffi';
import 'dart:io';
import 'package:catpic/main.dart';
import 'package:path/path.dart' as p;
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

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

DynamicLibrary openOnWindows() {
  final exeDir = File(Platform.resolvedExecutable).parent;
  final libraryNextToExe = File(p.join(exeDir.path, 'sqlite3.dll'));
  if (libraryNextToExe.existsSync())
    return DynamicLibrary.open(libraryNextToExe.path);
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final libraryNextToScript = File(p.join(scriptDir.path, 'sqlite3.dll'));
  return DynamicLibrary.open(libraryNextToScript.path);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = File(p.join(settingStore.documentDir, 'db.sqlite'));
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
