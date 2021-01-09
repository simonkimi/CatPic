class EhFilter {
  static int tagFilter(
      {bool misc,
      bool doujinsh,
      bool manga,
      bool artistCG,
      bool gameCG,
      bool imageSet,
      bool cosplay,
      bool asianPorn,
      bool nonh,
      bool western}) {
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
  /// [f_cats] 排除Tag
  static Map<String, dynamic> buildSimpleFilter(
      {String searchText, int excludeTag}) {
    return {
      'f_search': searchText ?? '',
      'f_cats': excludeTag ?? '',
    };
  }

  /// 构建高级搜索过滤器
  /// [searchText] 关键词
  /// [f_cats] 排除Tag
  /// [startPage] 开始页面
  /// [endPage] 结束页面
  /// [minRating] 最低星级
  static Map<String, dynamic> buildAdvanceFilter(
      {String searchText,
      int excludeTag,
      int startPage,
      int endPage,
      int minRating}) {
    return {
      'advsearch': 1,
      'f_search': searchText ?? '',
      'f_cats': excludeTag ?? '',
      'f_spf': startPage ?? '',
      'f_spt': endPage ?? '',
      'f_srdd': minRating
    };
  }
}
