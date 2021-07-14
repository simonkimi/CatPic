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
    required this.gtoken,
  });

  final String gid;
  final String gtoken;

  @observable
  int currentIndex;

  @observable
  var displayPageSlider = false;

  final pageSliderController = PageSliderController();

  var lastIdleTime = DateTime.now();

  var isIdle = true;

  @action
  void setPageSliderDisplay(bool value) {
    displayPageSlider = value;
    settingStore.setToolbarOpen(value);
  }

  @action
  Future<void> setIndex(int value) async {
    pageSliderController.setValue(value);
    currentIndex = value;
    await DB().ehReadHistoryDao.setPage(gid, gtoken, value);
  }
}
