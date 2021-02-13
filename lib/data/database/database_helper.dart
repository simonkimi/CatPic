import 'package:catpic/data/database/dao/host_dao.dart';

import 'dao/tag_dao.dart';
import 'dao/website_dao.dart';
import 'database.dart';

class DatabaseHelper {
  factory DatabaseHelper() => _databaseHelper;

  DatabaseHelper._internal();

  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();

  AppDatabase _database;

  Future<void> init() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  WebsiteDao get websiteDao => _database.websiteDao;

  HostDao get hostDao => _database.hostDao;

  TagDao get tagDao => _database.tagDao;
}
