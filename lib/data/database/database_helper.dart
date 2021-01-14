import 'package:catpic/data/database/dao/host_dao.dart';

import 'dao/website_dao.dart';
import 'database.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();

  factory DatabaseHelper() => _databaseHelper;

  AppDatabase _database;

  DatabaseHelper._internal();

  Future<void> init() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  WebsiteDao get websiteDao => _database.websiteDao;
  HostDao get hostDao => _database.hostDao;
}
