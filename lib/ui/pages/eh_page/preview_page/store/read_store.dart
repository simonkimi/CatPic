import 'package:catpic/ui/components/page_slider.dart';
import 'package:mobx/mobx.dart';

import '../../../../../main.dart';

part 'read_store.g.dart';

class ReadStore = ReadStoreBase with _$ReadStore;

abstract class ReadStoreBase with Store {
  ReadStoreBase({required this.currentIndex});

  @observable
  int currentIndex;

  @observable
  var displayPageSlider = false;

  final pageSliderController = PageSliderController();

  @action
  void setPageSliderDisplay(bool value) {
    displayPageSlider = value;
    settingStore.setToolbarOpen(value);
  }

  @action
  Future<void> setIndex(int value) async {
    pageSliderController.setValue(value);
    currentIndex = value;
  }
}
