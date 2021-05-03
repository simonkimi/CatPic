import 'dart:io';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:mobx/mobx.dart';
import 'package:dio_cache_interceptor/src/store/file_cache_store.dart';
import 'package:path/path.dart' as p;

part 'setting_store.g.dart';

class SettingStore = SettingStoreBase with _$SettingStore;

class ImageQuality {
  static const int preview = 0;
  static const int sample = 1;
  static const int raw = 2;
}

abstract class SettingStoreBase with Store {
  @observable
  var useCardWidget = true; // 卡片布局

  @observable
  var showCardDetail = true; // 显示底栏

  @observable
  var eachPageItem = 50; // 每页数量

  @observable
  var previewRowNum = 3; // 显示列数

  @observable
  var previewQuality = ImageQuality.preview; // 预览质量

  @observable
  var displayQuality = ImageQuality.sample; // 显示质量

  @observable
  var downloadQuality = ImageQuality.raw; // 下载质量

  @observable
  var downloadUri = ''; // 下载路径

  @observable
  var onlineTag = false;

  @observable
  var autoCompleteUseNetwork = true;

  @observable
  var saveModel = true;

  @observable
  var preloadingNumber = 3;

  @observable
  var toolbarOpen = true;

  late CacheOptions dioCacheOptions;

  var cacheDir = '';

  @action
  Future<void> init() async {
    final sp = SpUtil.getSp()!;
    useCardWidget = sp.getBool('useCardWidget') ?? true;
    showCardDetail = sp.getBool('showCardDetail') ?? true;
    eachPageItem = sp.getInt('eachPageItem') ?? 50;
    previewRowNum = sp.getInt('previewRowNum') ?? 3;
    downloadUri = sp.getString('downloadUri') ?? '';
    previewQuality = sp.getInt('previewQuality') ?? ImageQuality.preview;
    displayQuality = sp.getInt('displayQuality') ?? ImageQuality.sample;
    downloadQuality = sp.getInt('downloadQuality') ?? ImageQuality.raw;
    preloadingNumber = sp.getInt('preloadingNumber') ?? 3;
    onlineTag = sp.getBool('onlineTag') ?? false;
    autoCompleteUseNetwork = sp.getBool('autoCompleteUseNetwork') ?? true;
    saveModel = sp.getBool('saveModel') ?? true;
    toolbarOpen = sp.getBool('toolbarOpen') ?? true;

    cacheDir = sp.getString('cacheDir') ?? await getCacheDir();

    dioCacheOptions = CacheOptions(
      store: FileCacheStore(cacheDir),
      policy: CachePolicy.noCache,
      hitCacheOnErrorExcept: [401, 403],
      priority: CachePriority.normal,
      maxStale: const Duration(days: 30),
    );
  }

  Future<String> getCacheDir() async {
    final path = p.join(
        (Platform.isWindows
                ? await getApplicationSupportDirectory()
                : await getApplicationDocumentsDirectory())
            .path,
        'cache');
    final sp = SpUtil.getSp()!;
    sp.setString(cacheDir, path);
    return path;
  }

  @action
  void setToolbarOpen(bool value) {
    toolbarOpen = value;
    SpUtil.putBool('toolbarOpen', value);
  }

  @action
  void setPreloadingNumber(int value) {
    preloadingNumber = value;
    SpUtil.putInt('preloadingNumber', value);
  }

  @action
  void setSaveModel(bool value) {
    saveModel = value;
    SpUtil.putBool('saveModel', value);
  }

  @action
  void setAutoCompleteUseNetwork(bool value) {
    autoCompleteUseNetwork = value;
    SpUtil.putBool('autoCompleteUseNetwork', value);
  }

  @action
  void setOnlineTag(bool value) {
    onlineTag = value;
    SpUtil.putBool('onlineTag', value);
  }

  @action
  void setDownloadUri(String value) {
    downloadUri = value;
    SpUtil.putString('downloadUri', value);
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
