import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:dio/dio.dart';

import 'dio_builder.dart';

abstract class BaseClient {
  Dio dio;

  BaseClient(WebsiteEntity websiteEntity) {
    dio = DioBuilder.build(websiteEntity);
  }
}
