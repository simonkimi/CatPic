import 'package:mobx/mobx.dart';

part 'filter_store.g.dart';

class FilterStore = FilterStoreBase with _$FilterStore;

abstract class FilterStoreBase with Store {
  FilterStoreBase(this.searchText);

  @observable
  String searchText;

  @action
  void setSearchText(String value) => searchText = value;
}
