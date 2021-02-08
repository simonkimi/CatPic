import 'dart:typed_data';

import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/data/database/sp_helper.dart';
import 'package:catpic/network/misc/misc_network.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:mobx/mobx.dart';

part 'main_store.g.dart';

class MainStore = MainStoreBase with _$MainStore;

abstract class MainStoreBase with Store {
  MainStoreBase() {
    EventBusUtil().bus.on<EventSiteListChange>().listen((event) {
      print('event: EventSiteListChange');
      updateList();
    });
  }

  @observable
  List<WebsiteEntity> websiteList = [];

  @observable
  WebsiteEntity websiteEntity;

  @action
  Future<void> init() async {
    // 初始化数据
    final websiteDao = DatabaseHelper().websiteDao;
    websiteList = await websiteDao.getAll();
    final lastWebsite = SPHelper().pref.getInt('last_website') ?? -1;
    websiteEntity =
        websiteList.firstWhere((v) => v.id == lastWebsite, orElse: () => null);
    if (websiteEntity == null && websiteList.isNotEmpty) {
      setWebsite(websiteList[0]);
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
      if (websiteList.where((e) => e.id == websiteEntity.id ?? false).isEmpty) {
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
  Future<void> setWebsite(WebsiteEntity entity) async {
    if ((websiteEntity?.id ?? -1) != (entity?.id ?? -2)) {
      websiteEntity = entity;
      EventBusUtil().bus.fire(EventSiteChange());
      SPHelper().pref.setInt('last_website', websiteEntity?.id ?? -1);
    }
  }

  @action
  Future<void> setWebsiteFavicon(int entityId, Uint8List favicon) async {
    if (favicon.isNotEmpty) {
      final websiteDao = DatabaseHelper().websiteDao;
      final entity = await websiteDao.getById(entityId);
      entity.favicon = favicon;
      await websiteDao.updateSite(entity);
      if (websiteEntity?.id == entity.id ?? false) {
        websiteEntity = entity;
      }
      await updateList();
    }
  }
}

final mainStore = MainStore();
