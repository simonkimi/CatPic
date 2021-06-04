import 'package:catpic/data/database/database.dart';
import 'package:catpic/ui/components/page_slider.dart';
import 'package:mobx/mobx.dart';

import 'package:catpic/main.dart';

part 'read_store.g.dart';

class ReadStore = ReadStoreBase with _$ReadStore;

abstract class ReadStoreBase with Store {
  ReadStoreBase({
    required this.currentIndex,
    required this.gid,
  });

  final String gid;

  @observable
  int currentIndex;

  @observable
  var displayPageSlider = settingStore.toolbarOpen;

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
    await DB().ehHistoryDao.updatePage(gid, value);
  }
}
