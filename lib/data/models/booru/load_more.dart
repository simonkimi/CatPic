import 'package:mobx/mobx.dart';

abstract class ILoadMore<T> {

  ILoadMore(this.searchText);

  String searchText;

  Future<void> onLoadMore();

  Future<void> onRefresh();

  final observableList = ObservableList<T>();
}