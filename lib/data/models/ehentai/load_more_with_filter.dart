import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/network/api/ehentai/eh_filter.dart';

abstract class ILoadMoreWithFilter<T> extends ILoadMore<T> {
  ILoadMoreWithFilter(String searchText) : super(searchText);

  final EhAdvanceFilter filter = EhAdvanceFilter();

  EhAdvanceFilter currentFilter = EhAdvanceFilter();
}
