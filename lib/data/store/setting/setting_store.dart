import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_db_store/dio_cache_interceptor_db_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart' as p;

import 'package:catpic/themes.dart';
import 'package:synchronized/synchronized.dart';

part 'setting_store.g.dart';

class SettingStore = SettingStoreBase with _$SettingStore;

class ImageQuality {
  static const int preview = 0;
  static const int sample = 1;
  static const int raw = 2;
}

class DarkMode {
  static const int OPEN = 0;
  static const int CLOSE = 1;
  static const int FOLLOW_SYSTEM = 2;
}

class CardSize {
  static const int SMALL = 1;
  static const int MIDDLE = 2;
  static const int LARGE = 3;
  static const int HUGE = 4;

  static int of(int value) {
    switch (value) {
      case SMALL:
        return 100;
      case LARGE:
        return 200;
      case HUGE:
        return 250;
      case MIDDLE:
      default:
        return 150;
    }
  }
}

abstract class SettingStoreBase with Store {
  @observable
  var useCardWidget = true; // 卡片布局

  @observable
  var showCardDetail = true; // 显示底栏

  @observable
  var eachPageItem = 50; // 每页数量

  @observable
  var cardSize = 1; // 卡片大小

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

  @observable
  var theme = Themes.BLUE;

  @observable
  var dartMode = DarkMode.FOLLOW_SYSTEM;

  @observable
  var darkMask = true;

  @observable
  var ehTranslate = false;

  @observable
  var ehAutoCompute = false;

  @observable
  var ehDatabaseVersion = '';

  late CacheOptions dioCacheOptions;

  var documentDir = '';

  var translateMap = <String, String>{};

  @action
  Future<void> init() async {
    final sp = SpUtil.getSp()!;
    useCardWidget = sp.getBool('useCardWidget') ?? true;
    showCardDetail = sp.getBool('showCardDetail') ?? true;
    eachPageItem = sp.getInt('eachPageItem') ?? 50;
    cardSize = sp.getInt('cardSize') ?? CardSize.MIDDLE;
    downloadUri = sp.getString('downloadUri') ?? '';
    previewQuality = sp.getInt('previewQuality') ?? ImageQuality.preview;
    displayQuality = sp.getInt('displayQuality') ?? ImageQuality.sample;
    downloadQuality = sp.getInt('downloadQuality') ?? ImageQuality.raw;
    preloadingNumber = sp.getInt('preloadingNumber') ?? 3;
    onlineTag = sp.getBool('onlineTag') ?? false;
    autoCompleteUseNetwork = sp.getBool('autoCompleteUseNetwork') ?? true;
    saveModel = sp.getBool('saveModel') ?? true;
    toolbarOpen = sp.getBool('toolbarOpen') ?? true;
    documentDir = sp.getString('documentDir') ?? await getDocumentDir();
    theme = sp.getInt('theme') ?? Themes.BLUE;
    dartMode = sp.getInt('dartMode') ?? DarkMode.FOLLOW_SYSTEM;
    darkMask = sp.getBool('darkMask') ?? false;
    ehTranslate = sp.getBool('ehTranslate') ?? false;
    ehAutoCompute = sp.getBool('ehAutoCompute') ?? false;
    ehDatabaseVersion = sp.getString('ehDatabaseVersion') ?? '';

    if (ehDatabaseVersion.isNotEmpty) initTranslate();

    dioCacheOptions = CacheOptions(
      store: DbCacheStore(databasePath: p.join(documentDir, 'cache')),
      policy: CachePolicy.noCache,
      hitCacheOnErrorExcept: [401, 403],
      priority: CachePriority.normal,
      maxStale: const Duration(days: 30),
    );
  }

  Future<void> initTranslate() async {
    final list = await DB().translateDao.getAll();
    for (final tr in list) {
      translateMap[tr.name] = tr.translate;
    }
  }

  Future<String> getDocumentDir() async {
    final path = Platform.isWindows
        ? await getApplicationSupportDirectory()
        : await getApplicationDocumentsDirectory();

    final sp = SpUtil.getSp()!;
    sp.setString('documentDir', path.path);
    return path.path;
  }

  @action
  void setEhTranslate(bool value) {
    ehTranslate = value;
    SpUtil.putBool('ehTranslate', value);
  }

  @action
  void setEhAutoCompute(bool value) {
    ehAutoCompute = value;
    SpUtil.putBool('ehAutoCompute', value);
  }

  @action
  void setEhDatabaseVersion(String value) {
    ehDatabaseVersion = value;
    SpUtil.putString('ehDatabaseVersion', value);
  }

  @action
  void setDarkMask(bool value) {
    darkMask = value;
    SpUtil.putBool('darkMask', value);
  }

  @action
  void setDarkMode(int value) {
    dartMode = value;
    SpUtil.putInt('dartMode', value);
  }

  @action
  void setTheme(int value) {
    theme = value;
    SpUtil.putInt('theme', value);
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
  void setCardSize(int value) {
    cardSize = value;
    SpUtil.putInt('cardSize', value);
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

  final updateLock = Lock();

  Future<bool> updateEhDataBase([String? body]) async {
    BotToast.showText(text: I18n.g.start_update);
    final cancel = BotToast.showLoading();
    return await updateLock.synchronized<bool>(() async {
      try {
        final json = await getEhTranslate(body ?? (await getEhVersion()).item2);
        await DB().translateDao.clear();
        final entities = <EhTranslateTableCompanion>[];
        for (final namespace in json['data']) {
          for (final entity
              in (namespace['data'] as Map<String, dynamic>).entries) {
            entities.add(EhTranslateTableCompanion.insert(
              namespace: namespace['namespace'] as String,
              name: entity.key,
              translate: entity.value['name']['text'] as String,
              link: entity.value['intro']['raw'] as String,
            ));
          }
        }
        await DB().translateDao.addTrList(entities);
        setEhDatabaseVersion(json['head']['sha'] as String);
        initTranslate();
        BotToast.showText(text: I18n.g.update_success);
        return true;
      } catch (e) {
        BotToast.showText(text: I18n.g.update_fail(e.toString()));
        return false;
      } finally {
        cancel();
      }
    });
  }
}
