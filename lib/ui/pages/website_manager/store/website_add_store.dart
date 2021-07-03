import 'package:catpic/network/api/base_client.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:mobx/mobx.dart';

import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:moor/moor.dart';
import 'package:get/get.dart' hide Value;

part 'website_add_store.g.dart';

class WebsiteAddStore = WebsiteAddStoreBase with _$WebsiteAddStore;

abstract class WebsiteAddStoreBase with Store {
  WebsiteAddStoreBase(this.website)
      : websiteName = website?.name ?? '',
        websiteHost = website?.host ?? '',
        scheme = website?.scheme ?? WebsiteScheme.HTTPS.index,
        websiteType = website?.type ?? WebsiteType.GELBOORU.index,
        useDoH = website?.useDoH ?? false,
        directLink = website?.directLink ?? false,
        onlyHost = website?.onlyHost ?? false,
        username = website?.username ?? '',
        password = website?.password ?? '',
        cookies = ObservableMap.of(Map.fromEntries((website?.cookies ?? '')
            .split(';')
            .where((e) => e.isNotEmpty)
            .map((e) {
          final data = e.split('=');
          return MapEntry(data[0].trim(), data.skip(1).join('=').trim());
        })));

  WebsiteTableData? website;

  final pageController = PageController();

  @observable
  int currentPage = 0;

  @observable
  String websiteName;
  @observable
  String websiteHost;
  @observable
  int scheme;
  @observable
  int websiteType;
  @observable
  bool useDoH;
  @observable
  bool directLink;
  @observable
  bool onlyHost;
  @observable
  String username;
  @observable
  String password;
  @observable
  Uint8List? favicon;

  ObservableMap<String, String> cookies;

  @action
  void setWebsiteName(String value) => websiteName = value;

  @action
  void setCurrentPage(int page) {
    pageController.animateToPage(page,
        duration: 200.milliseconds, curve: Curves.easeOut);
    currentPage = page;
  }

  @action
  void setWebsiteHost(String value) {
    if (value.split('.').length < 2) {
      BotToast.showText(text: I18n.g.host_error);
      return;
    }
    websiteHost = value;
  }

  @action
  void setScheme(int value) => scheme = value;

  @action
  void setWebsiteType(int value) => websiteType = value;

  @action
  void setUseDoH(bool value) => useDoH = value;

  @action
  void setDirectLink(bool value) => directLink = value;

  @action
  void setOnlyHost(bool value) => onlyHost = value;

  @action
  void setUsername(String value) => username = value;

  @action
  void setPassword(String value) => password = value;

  @action
  Future<void> requestFavicon() async {
    favicon = await getFavicon(DioBuilder.buildByBase(
        host: websiteHost,
        scheme: scheme,
        useDoH: useDoH,
        cookies: cookies.entries.map((e) => '${e.key}=${e.value}').join('; '),
        websiteType: websiteType,
        directLink: directLink,
        onlyHost: onlyHost));
  }

  /// 保存网站
  Future<bool> saveWebsite() async {
    if (websiteHost.isEmpty) {
      BotToast.showText(text: I18n.g.host_empty);
      return false;
    }
    if (websiteName.isEmpty) {
      websiteName = websiteHost;
    }

    // 保存网站
    final websiteDao = DB().websiteDao;
    if (website != null) {
      await websiteDao.updateSite(website!.copyWith(
          name: websiteName,
          host: websiteHost,
          scheme: scheme,
          useDoH: useDoH,
          onlyHost: onlyHost,
          type: websiteType,
          directLink: directLink,
          username: username.isNotEmpty ? username : null,
          password: password.isNotEmpty ? password : null,
          cookies:
              cookies.entries.map((e) => '${e.key}=${e.value}').join('; ')));
    } else {
      final entity = WebsiteTableCompanion(
          favicon: Value(favicon ?? Uint8List.fromList([])),
          host: Value(websiteHost),
          name: Value(websiteName),
          scheme: Value(scheme),
          useDoH: Value(useDoH),
          type: Value(websiteType),
          directLink: Value(directLink),
          onlyHost: Value(onlyHost),
          username: username.isNotEmpty ? Value(username) : const Value(null),
          password: password.isNotEmpty ? Value(password) : const Value(null),
          cookies: Value(
              cookies.entries.map((e) => '${e.key}=${e.value}').join('; ')));
      final id = await websiteDao.insert(entity);
      final table = await websiteDao.getById(id);
      if (favicon == null)
        getFavicon(DioBuilder.build(table)).then((favicon) {
          mainStore.setWebsiteFavicon(id, favicon);
        });
    }
    mainStore.updateList();
    return true;
  }
}
