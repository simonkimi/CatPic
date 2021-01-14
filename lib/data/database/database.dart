import 'dart:async';
import 'dart:typed_data';
import 'package:catpic/data/database/dao/host_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dao/website_dao.dart';
import 'entity/host_entity.dart';
import 'entity/website_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [WebsiteEntity, HostEntity])
abstract class AppDatabase extends FloorDatabase {
  WebsiteDao get websiteDao;
  HostDao get hostDao;
}