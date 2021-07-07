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
      'f_sname': filter.searchGalleryName ? 'on' : '',
      'f_stags': filter.searchGalleryName ? 'on' : '',
      'f_storr': filter.searchTorrentFile ? 'on' : '',
      'f_sdt1': filter.searchLowPowerTag ? 'on' : '',
      'f_sh': filter.showExpungedGallery ? 'on' : '',
      'f_sp': filter.betweenPage ? 'on' : '',
      'f_spf': filter.betweenPage ? filter.pageStart.toString() : '',
      'f_spt': filter.betweenPage ? filter.pageEnd.toString() : '',
      'f_sfl': filter.disableLanguage ? 'on' : '',
      'f_sfu': filter.disableUploader ? 'on' : '',
      'f_sft': filter.disableTag ? 'on' : '',
      'f_sdesc': filter.searchGalleryDescription ? 'on' : '',
      'f_sto': filter.onlyShowGalleriesWithTorrents ? 'on' : '',
      'f_sdt2': filter.searchDownvotedTags ? 'on' : '',
      'f_sr': filter.minimumRating != -1 ? 'on' : '',
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
  EhAdvanceFilter({
    bool searchGalleryName = false,
    bool searchGalleryTag = false,
    bool searchTorrentFile = false,
    bool searchLowPowerTag = false,
    bool searchGalleryDescription = false,
    bool showExpungedGallery = false,
    bool onlyShowGalleriesWithTorrents = false,
    bool searchDownvotedTags = false,
    bool betweenPage = false,
    bool disableLanguage = false,
    bool disableUploader = false,
    bool disableTag = false,
    bool useAdvance = false,
    int pageStart = 0,
    int pageEnd = 0,
    int minimumRating = 0,
    Map<EhGalleryType, Rx<bool>>? typeFilter,
  })  : _searchGalleryName = searchGalleryName.obs,
        _searchGalleryTag = searchGalleryTag.obs,
        _searchTorrentFile = searchTorrentFile.obs,
        _searchLowPowerTag = searchLowPowerTag.obs,
        _searchGalleryDescription = searchGalleryDescription.obs,
        _showExpungedGallery = showExpungedGallery.obs,
        _onlyShowGalleriesWithTorrents = onlyShowGalleriesWithTorrents.obs,
        _searchDownvotedTags = searchDownvotedTags.obs,
        _betweenPage = betweenPage.obs,
        _disableLanguage = disableLanguage.obs,
        _disableUploader = disableUploader.obs,
        _disableTag = disableTag.obs,
        _useAdvance = useAdvance.obs,
        _pageStart = pageStart.obs,
        _pageEnd = pageEnd.obs,
        _minimumRating = minimumRating.obs,
        typeFilter = typeFilter ??
            <EhGalleryType, Rx<bool>>{
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

  final Rx<bool> _searchGalleryName;

  final Rx<bool> _searchGalleryTag;

  final Rx<bool> _searchTorrentFile;

  final Rx<bool> _searchLowPowerTag;

  final Rx<bool> _searchGalleryDescription;

  final Rx<bool> _showExpungedGallery;

  final Rx<bool> _onlyShowGalleriesWithTorrents;

  final Rx<bool> _searchDownvotedTags;

  final Rx<bool> _betweenPage;

  final Rx<int> _pageStart;

  final Rx<int> _pageEnd;

  final Rx<int> _minimumRating;

  final Rx<bool> _disableLanguage;

  final Rx<bool> _disableUploader;

  final Rx<bool> _disableTag;

  final Rx<bool> _useAdvance;

  bool get useAdvance => _useAdvance.value;

  set useAdvance(bool val) => _useAdvance.value = val;

  final Map<EhGalleryType, Rx<bool>> typeFilter;

  bool get disableTag => _disableTag.value;

  set disableTag(bool val) => _disableTag.value = val;

  bool get disableUploader => _disableUploader.value;

  set disableUploader(bool val) => _disableUploader.value = val;

  bool get disableLanguage => _disableLanguage.value;

  set disableLanguage(bool val) => _disableLanguage.value = val;

  int get minimumRating => _minimumRating.value;

  set minimumRating(int val) => _minimumRating.value = val;

  int get pageEnd => _pageEnd.value;

  set pageEnd(int val) => _pageEnd.value = val;

  int get pageStart => _pageStart.value;

  set pageStart(int val) => _pageStart.value = val;

  bool get betweenPage => _betweenPage.value;

  set betweenPage(bool val) => _betweenPage.value = val;

  bool get searchDownvotedTags => _searchDownvotedTags.value;

  set searchDownvotedTags(bool val) => _searchDownvotedTags.value = val;

  bool get onlyShowGalleriesWithTorrents =>
      _onlyShowGalleriesWithTorrents.value;

  set onlyShowGalleriesWithTorrents(bool val) =>
      _onlyShowGalleriesWithTorrents.value = val;

  bool get searchGalleryDescription => _searchGalleryDescription.value;

  set searchGalleryDescription(bool val) =>
      _searchGalleryDescription.value = val;

  bool get showExpungedGallery => _showExpungedGallery.value;

  set showExpungedGallery(bool val) => _showExpungedGallery.value = val;

  bool get searchLowPowerTag => _searchLowPowerTag.value;

  set searchLowPowerTag(bool val) => _searchLowPowerTag.value = val;

  bool get searchTorrentFile => _searchTorrentFile.value;

  set searchTorrentFile(bool val) => _searchTorrentFile.value = val;

  bool get searchGalleryName => _searchGalleryName.value;

  set searchGalleryName(bool val) => _searchGalleryName.value = val;

  bool get searchGalleryTag => _searchGalleryTag.value;

  set searchGalleryTag(bool val) => _searchGalleryTag.value = val;

  EhAdvanceFilter copy() => EhAdvanceFilter(
        betweenPage: betweenPage,
        disableLanguage: disableLanguage,
        disableTag: disableTag,
        disableUploader: disableUploader,
        minimumRating: minimumRating,
        onlyShowGalleriesWithTorrents: onlyShowGalleriesWithTorrents,
        pageEnd: pageEnd,
        pageStart: pageStart,
        searchDownvotedTags: searchDownvotedTags,
        searchGalleryDescription: searchGalleryDescription,
        searchGalleryName: searchGalleryName,
        searchGalleryTag: searchGalleryTag,
        searchLowPowerTag: searchLowPowerTag,
        searchTorrentFile: searchTorrentFile,
        showExpungedGallery: showExpungedGallery,
        useAdvance: useAdvance,
        typeFilter: <EhGalleryType, Rx<bool>>{
          EhGalleryType.Doujinshi:
              typeFilter[EhGalleryType.Doujinshi]!.value.obs,
          EhGalleryType.Manga: typeFilter[EhGalleryType.Manga]!.value.obs,
          EhGalleryType.Artist_CG:
              typeFilter[EhGalleryType.Artist_CG]!.value.obs,
          EhGalleryType.Game_CG: typeFilter[EhGalleryType.Game_CG]!.value.obs,
          EhGalleryType.Western: typeFilter[EhGalleryType.Western]!.value.obs,
          EhGalleryType.Non_H: typeFilter[EhGalleryType.Non_H]!.value.obs,
          EhGalleryType.Image_Set:
              typeFilter[EhGalleryType.Image_Set]!.value.obs,
          EhGalleryType.Cosplay: typeFilter[EhGalleryType.Cosplay]!.value.obs,
          EhGalleryType.Asian_Porn:
              typeFilter[EhGalleryType.Asian_Porn]!.value.obs,
          EhGalleryType.Misc: typeFilter[EhGalleryType.Misc]!.value.obs,
        },
      );
}
