import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/ehentai/gallery_img_model.dart';
import 'package:catpic/data/models/ehentai/gallery_model.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/base_adapter.dart';
import 'package:catpic/network/api/ehentai/eh_client.dart';
import 'package:catpic/network/parser/ehentai/gallery_img_parser.dart';
import 'package:catpic/network/parser/ehentai/gallery_parser.dart';
import 'package:catpic/network/parser/ehentai/preview_parser.dart';
import 'package:dio/dio.dart';
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
    final model = await compute(PreviewParser.parse, str);
    return await previewTranslateHook(model);
  }

  Future<PreviewModel> watched({
    required Map<String, dynamic> filter,
    required int page,
  }) async {
    final str = await client.getWatched(filter: filter, page: page);
    final model = await compute(PreviewParser.parse, str);
    return await previewTranslateHook(model);
  }

  Future<PreviewModel> popular() async {
    final str = await client.getPopular();
    final model = await compute(PreviewParser.parse, str);
    return await previewTranslateHook(model);
  }

  Future<GalleryModel> gallery({
    required String gid,
    required String gtoken,
    required int page,
    CancelToken? cancelToken,
  }) async {
    final str =
        await client.getGallery(gid, gtoken, page.toString(), cancelToken);
    final model = await compute(GalleryParser.parse, str);
    for (final tagList in model.tags) {
      tagList.keyTranslate = settingStore.translateMap[tagList.key];
      for (final tag in tagList.value) {
        tag.translate = settingStore.translateMap[tag.value];
      }
    }
    return model;
  }

  Future<GalleryImgModel> galleryImage(String url) async {
    final reg = RegExp('s/(.+?)/(.+)');
    final match = reg.firstMatch(url)!;
    final token = match[1]!;
    final galleryPage = match[2]!;

    final str = await client.galleryImage(token, galleryPage);
    return await compute(GalleryImgParser.parse, str);
  }

  Future<PreviewModel> previewTranslateHook(PreviewModel model) async {
    for (final item in model.items) {
      for (final tag in item.keyTags) {
        final tagParam = tag.tag.split(':');
        if (tagParam.length == 2) {
          if (tagParam[0] == 'f') tagParam[0] = '♀';
          if (tagParam[0] == 'm') tagParam[0] = '♂';
          tag.translate =
              '${tagParam[0]}:${settingStore.translateMap[tagParam[1]] ?? tagParam[1]}';
        } else if (tagParam.length == 1) {
          tag.translate = settingStore.translateMap[tag.tag];
        }
      }
    }
    return model;
  }
}
