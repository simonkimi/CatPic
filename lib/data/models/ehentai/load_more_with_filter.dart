import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/network/api/ehentai/eh_filter.dart';

abstract class ILoadMoreWithFilter<T> extends ILoadMore<T> {
  ILoadMoreWithFilter(
    String searchText, {
    EhAdvanceFilter? baseFilter,
  })  : filter = baseFilter?.copy() ?? EhAdvanceFilter(),
        currentFilter = baseFilter?.copy() ?? EhAdvanceFilter(),
        super(searchText);

  // ui控制的filter
  final EhAdvanceFilter filter;

  // 网络读取的filter
  EhAdvanceFilter currentFilter;
}
