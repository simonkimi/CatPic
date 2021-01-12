import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dao/website_dao.dart';
import 'entity/website_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [WebsiteEntity])
abstract class AppDatabase extends FloorDatabase {
  WebsiteDao get websiteDao;
}