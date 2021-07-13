import 'dart:typed_data';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:sp_util/sp_util.dart';
import 'package:mobx/mobx.dart';
import 'package:catpic/utils/utils.dart';

part 'main_store.g.dart';

class MainStore = MainStoreBase with _$MainStore;

abstract class MainStoreBase with Store {
  @observable
  List<WebsiteTableData> websiteList = [];

  @observable
  WebsiteTableData? websiteEntity;

  @observable
  Uint8List? websiteIcon;

  @observable
  int searchPageCount = 0;

  @action
  void addSearchPage() => searchPageCount++;

  @action
  void descSearchPage() => searchPageCount--;

  @action
  Future<void> init() async {
    // 初始化数据
    final websiteDao = DB().websiteDao;
    websiteList = await websiteDao.getAll();
    final lastWebsite = SpUtil.getInt('last_website') ?? -1;

    final oldWebsite = websiteList.get((v) => v.id == lastWebsite);
    if (oldWebsite != null) {
      setWebsite(oldWebsite);
    } else {
      if (websiteList.isNotEmpty) {
        setWebsite(websiteList[0]);
      }
    }
    // 尝试获取图标
    websiteList.where((e) => e.favicon.isEmpty).forEach((element) {
      getFavicon(DioBuilder.build(element)).then((favicon) {
        setWebsiteFavicon(element.id, favicon);
      });
    });
  }

  @action
  Future<void> updateList() async {
    final websiteDao = DB().websiteDao;
    websiteList = await websiteDao.getAll();
    // 判断当前网站是否被删
    if (websiteEntity != null) {
      if (websiteList.get((e) => e.id == websiteEntity!.id) == null) {
        await setWebsite(websiteList.isNotEmpty ? websiteList[0] : null);
        return;
      } else {
        setWebsiteWithoutNotification(
            websiteList.get((e) => e.id == websiteEntity!.id)!);
      }
    }

    // 判断是有候选网站
    if (websiteEntity == null && websiteList.isNotEmpty) {
      await setWebsite(websiteList[0]);
    }
  }

  @action
  Future<void> setWebsite(WebsiteTableData? entity) async {
    if ((websiteEntity?.id ?? -1) != (entity?.id ?? -2)) {
      print('setWebsite ${entity?.name}');
      websiteEntity = entity;
      if (entity != null)
        await DB()
            .websiteDao
            .updateSite(entity.copyWith(lastOpen: DateTime.now().millisecond));
      websiteIcon = entity?.favicon;
      EventBusUtil().bus.fire(EventSiteChange());
      SpUtil.putInt('last_website', websiteEntity?.id ?? -1);
    }
  }

  @action
  void setWebsiteWithoutNotification(WebsiteTableData entity) {
    if ((websiteEntity?.id ?? -1) == (entity.id)) {
      websiteEntity = entity;
      websiteIcon = entity.favicon;
      SpUtil.putInt('last_website', websiteEntity?.id ?? -1);
    }
  }

  Uint8List? getStorage() => websiteEntity!.storage;

  @action
  Future<void> setWebsiteFavicon(int entityId, Uint8List favicon) async {
    if (favicon.isNotEmpty) {
      final websiteDao = DB().websiteDao;
      final entity = await websiteDao.getById(entityId);

      if (entity != null) {
        await websiteDao.updateSite(entity.copyWith(favicon: favicon));
        if (websiteEntity?.id == entity.id) {
          websiteEntity = entity;
        }
      }
      if (websiteEntity?.id == entityId) {
        websiteIcon = favicon;
      }
      await updateList();
    }
  }

  @action
  Future<void> deleteWebsite(WebsiteTableData entity) async {
    DB().websiteDao.remove(entity);
    DB().downloadDao.onWebsiteDelete(entity.id);
    DB().ehDownloadDao.onWebsiteDelete(entity.id);
    updateList();
  }
}
