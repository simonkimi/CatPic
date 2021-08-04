import 'package:catpic/data/models/basic.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:dio/dio.dart';

abstract class Adapter {
  IWebsiteEntity get website;

  Dio get dio;

  BaseClient get client;
}
