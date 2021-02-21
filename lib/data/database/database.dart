import 'dart:async';
import 'dart:typed_data';

import 'package:catpic/data/database/dao/download_dao.dart';
import 'package:catpic/data/database/dao/history_dao.dart';
import 'package:catpic/data/database/dao/host_dao.dart';
import 'package:catpic/data/database/entity/history_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/history_dao.dart';
import 'dao/tag_dao.dart';
import 'dao/website_dao.dart';
import 'entity/download_entity.dart';
import 'entity/host_entity.dart';
import 'entity/tag_entity.dart';
import 'entity/website_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [
  WebsiteEntity,
  HostEntity,
  TagEntity,
  HistoryEntity,
  DownloadEntity,
])
abstract class AppDatabase extends FloorDatabase {
  WebsiteDao get websiteDao;

  HostDao get hostDao;

  TagDao get tagDao;

  HistoryDao get historyDao;

  DownloadDao get downloadDao;
}
