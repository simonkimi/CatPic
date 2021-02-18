import 'package:sp_util/sp_util.dart';
import 'package:mobx/mobx.dart';

part 'setting_store.g.dart';

final settingStore = SettingStore();

class SettingStore = SettingStoreBase with _$SettingStore;

class ImageQuality {
  static const int preview = 0;
  static const int sample = 1;
  static const int raw = 2;
}

abstract class SettingStoreBase with Store {
  @observable
  bool useCardWidget = true;

  @observable
  bool showCardDetail = true;

  @observable
  int eachPageItem = 50;

  @observable
  int previewRowNum = 3;

  @observable
  int previewQuality = ImageQuality.preview;

  @observable
  int displayQuality = ImageQuality.sample;

  @observable
  int downloadQuality = ImageQuality.raw;

  @action
  Future<void> init() async {
    useCardWidget = SpUtil.getBool('useCardWidget', defValue: true);
    showCardDetail = SpUtil.getBool('showCardDetail', defValue: true);
    eachPageItem = SpUtil.getInt('eachPageItem', defValue: 50);
    previewRowNum = SpUtil.getInt('previewRowNum', defValue: 3);
    previewQuality =
        SpUtil.getInt('previewQuality', defValue: ImageQuality.preview);
    displayQuality =
        SpUtil.getInt('displayQuality', defValue: ImageQuality.sample);
    downloadQuality =
        SpUtil.getInt('downloadQuality', defValue: ImageQuality.raw);
  }

  @action
  void setPreviewQuality(int value) {
    previewQuality = value;
    SpUtil.putInt('previewQuality', value);
  }

  @action
  void setDisplayQuality(int value) {
    displayQuality = value;
    SpUtil.putInt('displayQuality', value);
  }

  @action
  void setDownloadQuality(int value) {
    downloadQuality = value;
    SpUtil.putInt('downloadQuality', value);
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

  @action
  void setShowCardDetail(bool value) {
    showCardDetail = value;
    SpUtil.putBool('showCardDetail', value);
  }

  @action
  void setEachPageItem(int value) {
    eachPageItem = value;
    SpUtil.putInt('eachPageItem', value);
  }
}
