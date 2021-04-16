import 'dart:typed_data';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:sp_util/sp_util.dart';
import 'package:mobx/mobx.dart';

part 'main_store.g.dart';

class MainStore = MainStoreBase with _$MainStore;

abstract class MainStoreBase with Store {
  @observable
  List<WebsiteTableData> websiteList = [];

  @observable
  WebsiteTableData? websiteEntity;

  @action
  Future<void> init() async {
    // 初始化数据
    final websiteDao = DatabaseHelper().websiteDao;
    websiteList = await websiteDao.getAll();
    final lastWebsite = SpUtil.getInt('last_website') ?? -1;

    final availList = websiteList.where((v) => v.id == lastWebsite);
    if (availList.isNotEmpty) {
      websiteEntity = availList.toList()[0];
      if (websiteEntity == null && websiteList.isNotEmpty) {
        setWebsite(websiteList[0]);
      }
    }
    // 尝试获取图标
    websiteList.where((e) => e.favicon.isEmpty).forEach((element) {
      getFavicon(element).then((favicon) {
        setWebsiteFavicon(element.id, favicon);
      });
    });
  }

  @action
  Future<void> updateList() async {
    final websiteDao = DatabaseHelper().websiteDao;
    websiteList = await websiteDao.getAll();
    // 判断当前网站是否被删
    if (websiteEntity != null) {
      if (websiteList.where((e) => e.id == websiteEntity!.id).isEmpty) {
        await setWebsite(websiteList.isNotEmpty ? websiteList[0] : null);
        return;
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
      websiteEntity = entity;
      EventBusUtil().bus.fire(EventSiteChange());
      SpUtil.putInt('last_website', websiteEntity?.id ?? -1);
    }
  }

  @action
  Future<void> setWebsiteWithoutNotification(WebsiteTableData? entity) async {
    if ((websiteEntity?.id ?? -1) != (entity?.id ?? -2)) {
      websiteEntity = entity;
      SpUtil.putInt('last_website', websiteEntity?.id ?? -1);
    }
  }

  @action
  Future<void> setWebsiteFavicon(int entityId, Uint8List favicon) async {
    if (favicon.isNotEmpty) {
      final websiteDao = DatabaseHelper().websiteDao;
      final entity = await websiteDao.getById(entityId);

      if (entity != null) {
        await websiteDao.updateSite(entity.copyWith(favicon: favicon));
        if (websiteEntity?.id == entity.id) {
          websiteEntity = entity;
        }
      }
      await updateList();
    }
  }
}
