import 'package:catpic/utils/sp_util.dart';
import 'package:mobx/mobx.dart';

part 'setting_store.g.dart';

final settingStore = SettingStore();

class SettingStore = SettingStoreBase with _$SettingStore;

abstract class SettingStoreBase with Store {
  @observable
  bool useCardWidget = true;

  @observable
  bool showCardDetail = true;

  @observable
  int eachPageItem = 50;

  int previewRowNum = 3;

  @action
  Future<void> init() async {
    useCardWidget = SpUtil.getBool('useCardWidget') ?? true;
    showCardDetail = SpUtil.getBool('showCardDetail') ?? true;
    eachPageItem = SpUtil.getInt('eachPageItem') ?? 50;
    previewRowNum = SpUtil.getInt('previewRowNum') ?? 3;
  }

  @action
  void setUseCardWidget(bool value) {
    useCardWidget = value;
    SpUtil.putBool('useCardWidget', value);
  }

  @action
  void setPreviewRowNum(int value) {
    previewRowNum = value;
    SpUtil.putInt('previewRowNum', value);
  }
}
