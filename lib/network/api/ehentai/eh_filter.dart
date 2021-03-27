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

  /// 构建搜索过滤器
  /// [searchText] 关键词
  /// [excludeTag] 排除Tag, 由[tagFilter]构建
  /// [startPage] 开始页面
  /// [endPage] 结束页面
  /// [minRating] 最低星级
  static Map<String, dynamic> buildAdvanceFilter({
    String? searchText,
    int? excludeTag,
    int? startPage,
    int? endPage,
    int? minRating,
    int? page,
  }) {
    return {
      'advsearch': 1,
      'f_search': searchText ?? '',
      'f_cats': excludeTag ?? '',
      'f_spf': startPage ?? '',
      'f_spt': endPage ?? '',
      'f_srdd': minRating ?? '',
      'page': page ?? 0
    };
  }
}
