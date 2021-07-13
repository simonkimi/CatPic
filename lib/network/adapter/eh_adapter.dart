import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/ehentai/favourite_model.dart';
import 'package:catpic/data/models/ehentai/gallery_img_model.dart';
import 'package:catpic/data/models/ehentai/gallery_model.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/base_adapter.dart';
import 'package:catpic/network/api/ehentai/eh_client.dart';
import 'package:catpic/network/parser/ehentai/favourite_parser.dart';
import 'package:catpic/network/parser/ehentai/gallery_img_parser.dart';
import 'package:catpic/network/parser/ehentai/gallery_parser.dart';
import 'package:catpic/network/parser/ehentai/preview_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart' as gallery_pb;

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
    return previewTranslateHook(model);
  }

  Future<PreviewModel> watched({
    required Map<String, dynamic> filter,
    required int page,
  }) async {
    final str = await client.getWatched(filter: filter, page: page);
    final model = await compute(PreviewParser.parse, str);
    if (model.exception != null) throw model.exception!;
    return previewTranslateHook(model);
  }

  Future<PreviewModel> popular() async {
    final str = await client.getPopular();
    final model = await compute(PreviewParser.parse, str);
    return previewTranslateHook(model);
  }

  Future<GalleryModel> gallery({
    required String gid,
    required String gtoken,
    required int page,
    CancelToken? cancelToken,
  }) async {
    GalleryModel? model;

    if (page == 0) {
      final db = await DB().galleryCacheDao.get(gid, gtoken);
      if (db != null) {
        model =
            GalleryModel.fromPb(gallery_pb.GalleryModel.fromBuffer(db.data));
      }
    }

    if (model == null) {
      final str =
          await client.getGallery(gid, gtoken, page.toString(), cancelToken);
      model = await compute(GalleryParser.parse, str);
      DB().galleryCacheDao.insert(GalleryCacheTableCompanion.insert(
            gid: gid,
            token: gtoken,
            data: model!.toPb().writeToBuffer(),
          ));
    }

    for (final tagList in model.tags) {
      tagList.keyTranslate = settingStore.translateMap[tagList.key];
      for (final tag in tagList.value) {
        tag.translate = settingStore.translateMap[tag.value];
      }
    }
    return model;
  }

  Future<GalleryImgModel> galleryImage({
    required String gid,
    required String gtoken,
    required int page,
  }) async {
    final str = await client.galleryImage(gid: gid, gtoken: gtoken, page: page);
    return await compute(GalleryImgParser.parse, str);
  }

  Future<EhFavouriteModel> favourite({
    required int favcat,
    required int page,
    required String searchText,
  }) async {
    final str = await client.favourite(
        favcat: favcat, page: page, searchText: searchText);
    final previewModel = await compute(PreviewParser.parse, str);
    if (previewModel.exception != null) throw previewModel.exception!;
    final favouriteList = await compute(EhFavouriteParser.parse, str);
    previewTranslateHook(previewModel);
    return EhFavouriteModel(
        favourites: favouriteList, previewModel: previewModel);
  }

  PreviewModel previewTranslateHook(PreviewModel model) {
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
