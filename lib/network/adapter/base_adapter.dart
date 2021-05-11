import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:dio/dio.dart';

abstract class Adapter {
  WebsiteTableData get website;

  Dio get dio;

  BaseClient get client;
}
