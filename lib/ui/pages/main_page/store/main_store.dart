import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/data/database/sp_helper.dart';
import 'package:mobx/mobx.dart';

part 'main_store.g.dart';

class MainStore = MainStoreBase with _$MainStore;

abstract class MainStoreBase with Store {
  @observable
  List<WebsiteEntity> websiteList = [];

  @observable
  WebsiteEntity websiteEntity;

  @action
  Future<void> init() async {
    var websiteDao = DatabaseHelper().websiteDao;
    websiteList = await websiteDao.getAll();
    var lastWebsite = SPHelper().pref.getInt("last_website") ?? -1;
    websiteEntity =
        websiteList.firstWhere((v) => v.id == lastWebsite, orElse: () => null);
    if (websiteEntity == null && websiteList.length != 0) {
      websiteEntity = websiteList[0];
      SPHelper().pref.setInt("last_website", websiteEntity.id);
    }
  }

  @action
  Future<void> updateList() async {
    var websiteDao = DatabaseHelper().websiteDao;
    websiteList = await websiteDao.getAll();
    // 判断当前网站是否被删
    if (websiteEntity != null) {
      if (websiteList.where((e) => e.id == websiteEntity.id ?? false).isEmpty) {
        websiteEntity = websiteList[0];
      }
    }
    // 判断是有候选网站
    if (websiteEntity == null && websiteList.isNotEmpty) {
      websiteEntity = websiteList[0];
    }
    // 写入上次网站记忆
    if (websiteEntity != null) {
      SPHelper().pref.setInt("last_website", websiteEntity.id);
    }
  }

  Future<void> setWebsite(WebsiteEntity entity) async {
    websiteEntity = entity;
    SPHelper().pref.setInt("last_website", websiteEntity.id);

  }
}

var mainStore = MainStore();
