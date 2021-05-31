import 'package:mobx/mobx.dart';

part 'read_store.g.dart';

class ReadStore = ReadStoreBase with _$ReadStore;

abstract class ReadStoreBase with Store {
  ReadStoreBase({required this.currentIndex});

  @observable
  int currentIndex;

  @action
  Future<void> setIndex(int value) async {
    currentIndex = value;
  }
}
