import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'dio_builder.dart';

abstract class BaseClient {
  Dio dio;

  BaseClient(BuildContext context, WebsiteEntity websiteEntity) {
    dio = DioBuilder.build(context, websiteEntity);
  }

}
