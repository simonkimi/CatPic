import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/adapter/base_adapter.dart';
import 'package:catpic/network/api/ehentai/eh_client.dart';
import 'package:catpic/network/parser/ehentai/preview_parser.dart';
import 'package:dio/src/dio.dart';
import 'package:flutter/foundation.dart';

class EHAdapter extends Adapter {
  EHAdapter(this.websiteEntity) : client = EhClient(websiteEntity);

  final WebsiteTableData websiteEntity;

  @override
  final EhClient client;

  @override
  Dio get dio => client.dio;

  @override
  WebsiteTableData get website => websiteEntity;

  Future<PreviewModel> index({
    required Map<String, dynamic> filter,
    required int page,
  }) async {
    final str = await client.getIndex(filter: filter, page: page);
    return await compute(PreviewParser.parse, str);
  }
}
