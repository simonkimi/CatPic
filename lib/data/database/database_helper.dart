import 'dao/website_dao.dart';
import 'database.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();

  factory DatabaseHelper() => _databaseHelper;

  AppDatabase _database;

  DatabaseHelper._internal() {
    initDataBase();
  }

  initDataBase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  WebsiteDao get websiteDao => _database.websiteDao;
}
