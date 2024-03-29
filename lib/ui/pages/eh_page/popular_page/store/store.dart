import 'package:catpic/data/models/ehentai/load_more_with_filter.dart';
import 'package:catpic/data/models/gen/eh_preview.pb.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

class EhPopularResultStore = EhPopularResultBase with _$EhPopularResultStore;

abstract class EhPopularResultBase extends ILoadMoreWithFilter<PreViewItemModel>
    with Store {
  EhPopularResultBase(this.adapter) : super('');

  final EHAdapter adapter;

  @override
  @observable
  bool isLoading = false;

  @override
  @action
  Future<void> onDataChange() async {}

  @override
  Future<List<PreViewItemModel>> loadPage(int page) async {
    return (await adapter.popular()).items;
  }

  @override
  int get pageItemCount => 50;

  @override
  bool isItemExist(PreViewItemModel item) => false;
}
