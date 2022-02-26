import 'dart:ffi';
import 'dart:io';

import 'package:catpic/data/database/dao/download_dao.dart';
import 'package:catpic/data/database/dao/history_dao.dart';
import 'package:catpic/data/database/dao/host_dao.dart';
import 'package:catpic/data/database/dao/tag_dao.dart';
import 'package:catpic/data/database/dao/website_dao.dart';
import 'package:catpic/data/database/entity/eh_read_history.dart';
import 'package:catpic/main.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import 'dao/eh_download_dao.dart';
import 'dao/eh_image_dao.dart';
import 'dao/eh_read_history_dao.dart';
import 'dao/gallery_cache_dao.dart';
import 'dao/gallery_history_dao.dart';
import 'dao/translate_dao.dart';
import 'entity/download.dart';
import 'entity/eh_download.dart';
import 'entity/eh_gallery_historary.dart';
import 'entity/eh_gallery_preview_img_cache.dart';
import 'entity/eh_image_cache.dart';
import 'entity/eh_image_sha.dart';
import 'entity/eh_translate.dart';
import 'entity/gallery_cache.dart';
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
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [
  DownloadTable,
  HistoryTable,
  HostTable,
  TagTable,
  WebsiteTable,
  EhTranslateTable,
  GalleryCacheTable,
  EhGalleryHistoryTable,
  EhDownloadTable,
  EhDownloadShaTable,
  EhReadHistoryTable,
  EhGalleryPreviewImgCache,
  EhImageCache,
], daos: [
  DownloadDao,
  HistoryDao,
  HostDao,
  TagDao,
  WebsiteDao,
  TranslateDao,
  GalleryCacheDao,
  GalleryHistoryDao,
  EhReadHistoryDao,
  EhDownloadDao,
  EhImageDao,
])
class AppDataBase extends _$AppDataBase {
  AppDataBase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onUpgrade: (Migrator m, from, to) async {
        if (from == 1 && to == 2) {
          await m.addColumn(ehImageCache, ehImageCache.page);
        }
      });
}

class DB {
  factory DB() => _db;

  DB._();

  static final DB _db = DB._();
  final AppDataBase _database = AppDataBase();

  WebsiteDao get websiteDao => _database.websiteDao;

  HostDao get hostDao => _database.hostDao;

  TagDao get tagDao => _database.tagDao;

  HistoryDao get historyDao => _database.historyDao;

  DownloadDao get downloadDao => _database.downloadDao;

  TranslateDao get translateDao => _database.translateDao;

  GalleryCacheDao get galleryCacheDao => _database.galleryCacheDao;

  GalleryHistoryDao get galleryHistoryDao => _database.galleryHistoryDao;

  EhDownloadDao get ehDownloadDao => _database.ehDownloadDao;

  EhReadHistoryDao get ehReadHistoryDao => _database.ehReadHistoryDao;

  EhImageDao get ehImageDao => _database.ehImageDao;
}
