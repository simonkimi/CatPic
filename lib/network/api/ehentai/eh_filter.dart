import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:get/get.dart';
import 'package:catpic/utils/utils.dart';

class EhFilter {
  static int tagFilter({
    required bool misc,
    required bool doujinsh,
    required bool manga,
    required bool artistCG,
    required bool gameCG,
    required bool imageSet,
    required bool cosplay,
    required bool asianPorn,
    required bool nonh,
    required bool western,
  }) {
    var filter = 0;
    filter += !misc ? 1 << 0 : 0;
    filter += !doujinsh ? 1 << 1 : 0;
    filter += !manga ? 1 << 2 : 0;
    filter += !artistCG ? 1 << 3 : 0;
    filter += !gameCG ? 1 << 4 : 0;
    filter += !imageSet ? 1 << 5 : 0;
    filter += !cosplay ? 1 << 6 : 0;
    filter += !asianPorn ? 1 << 7 : 0;
    filter += !nonh ? 1 << 8 : 0;
    filter += !western ? 1 << 9 : 0;
    return filter;
  }

  static Map<String, String> buildBasicFilter({
    required EhAdvanceFilter filter,
    String? searchText,
  }) {
    return {
      'f_search': searchText ?? '',
      'f_cats': EhFilter.tagFilter(
        misc: filter.typeFilter[EhGalleryType.Misc]!.value,
        doujinsh: filter.typeFilter[EhGalleryType.Doujinshi]!.value,
        manga: filter.typeFilter[EhGalleryType.Manga]!.value,
        artistCG: filter.typeFilter[EhGalleryType.Artist_CG]!.value,
        gameCG: filter.typeFilter[EhGalleryType.Game_CG]!.value,
        imageSet: filter.typeFilter[EhGalleryType.Image_Set]!.value,
        cosplay: filter.typeFilter[EhGalleryType.Cosplay]!.value,
        asianPorn: filter.typeFilter[EhGalleryType.Asian_Porn]!.value,
        nonh: filter.typeFilter[EhGalleryType.Non_H]!.value,
        western: filter.typeFilter[EhGalleryType.Western]!.value,
      ).toString(),
    };
  }

  /// 构建搜索过滤器
  /// [searchText] 关键词
  /// [excludeTag] 排除Tag, 由[tagFilter]构建
  /// [startPage] 开始页面
  /// [endPage] 结束页面
  /// [minRating] 最低星级
  static Map<String, String> buildAdvanceFilter({
    required EhAdvanceFilter filter,
    String? searchText,
  }) {
    return {
      'advsearch': '1',
      'f_search': searchText ?? '',
      'f_sname': filter.searchGalleryName.value ? 'on' : '',
      'f_stags': filter.searchGalleryName.value ? 'on' : '',
      'f_storr': filter.searchTorrentFile.value ? 'on' : '',
      'f_sdt1': filter.searchLowPowerTag.value ? 'on' : '',
      'f_sh': filter.showExpungedGallery.value ? 'on' : '',
      'f_sp': filter.betweenPage.value ? 'on' : '',
      'f_spf': filter.betweenPage.value ? filter.pageStart.toString() : '',
      'f_spt': filter.betweenPage.value ? filter.pageEnd.toString() : '',
      'f_sfl': filter.disableLanguage.value ? 'on' : '',
      'f_sfu': filter.disableUploader.value ? 'on' : '',
      'f_sft': filter.disableTag.value ? 'on' : '',
      'f_sdesc': filter.searchGalleryDescription.value ? 'on' : '',
      'f_sto': filter.onlyShowGalleriesWithTorrents.value ? 'on' : '',
      'f_sdt2': filter.searchDownvotedTags.value ? 'on' : '',
      'f_sr': filter.minimumRating.value != -1 ? 'on' : '',
      'f_srdd':
      filter.minimumRating != -1 ? filter.minimumRating.toString() : '',
      'f_cats': EhFilter.tagFilter(
        misc: filter.typeFilter[EhGalleryType.Misc]!.value,
        doujinsh: filter.typeFilter[EhGalleryType.Doujinshi]!.value,
        manga: filter.typeFilter[EhGalleryType.Manga]!.value,
        artistCG: filter.typeFilter[EhGalleryType.Artist_CG]!.value,
        gameCG: filter.typeFilter[EhGalleryType.Game_CG]!.value,
        imageSet: filter.typeFilter[EhGalleryType.Image_Set]!.value,
        cosplay: filter.typeFilter[EhGalleryType.Cosplay]!.value,
        asianPorn: filter.typeFilter[EhGalleryType.Asian_Porn]!.value,
        nonh: filter.typeFilter[EhGalleryType.Non_H]!.value,
        western: filter.typeFilter[EhGalleryType.Western]!.value,
      ).toString(),
    }.trim;
  }
}

class EhAdvanceFilter {
  final searchGalleryName = true.obs;

  final searchGalleryTag = true.obs;

  final searchTorrentFile = false.obs;

  final searchLowPowerTag = false.obs;

  final searchGalleryDescription = false.obs;

  final showExpungedGallery = false.obs;

  final onlyShowGalleriesWithTorrents = false.obs;

  final searchDownvotedTags = false.obs;

  final betweenPage = false.obs;

  final pageStart = 0.obs;

  final pageEnd = 0.obs;

  final minimumRating = (-1).obs;

  final disableLanguage = false.obs;

  final disableUploader = false.obs;

  final disableTag = false.obs;

  final typeFilter = <EhGalleryType, Rx<bool>>{
    EhGalleryType.Doujinshi: true.obs,
    EhGalleryType.Manga: true.obs,
    EhGalleryType.Artist_CG: true.obs,
    EhGalleryType.Game_CG: true.obs,
    EhGalleryType.Western: true.obs,
    EhGalleryType.Non_H: true.obs,
    EhGalleryType.Image_Set: true.obs,
    EhGalleryType.Cosplay: true.obs,
    EhGalleryType.Asian_Porn: true.obs,
    EhGalleryType.Misc: true.obs,
  };
}