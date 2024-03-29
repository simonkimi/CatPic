import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/data/models/basic.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:mobx/mobx.dart';

part 'website_add_store.g.dart';

class WebsiteAddStore = WebsiteAddStoreBase with _$WebsiteAddStore;

abstract class WebsiteAddStoreBase with Store {
  WebsiteAddStoreBase(this.website)
      : websiteName = website?.name ?? '',
        websiteHost = website?.host ?? '',
        scheme = website?.scheme ?? WebsiteScheme.HTTPS.index,
        websiteType = website?.type ?? WebsiteType.UNKNOWN,
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

  // ui
  @observable
  int currentPage = 0;
  final pageController = PageController();
  @observable
  var isFavLoading = false;
  @observable
  var isCheckingType = false;
  @observable
  var isFirstCheckType = true;
  CancelToken? cancelToken;

  // 数据库字段
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
    if (isFavLoading == true || (favicon != null && favicon!.isNotEmpty))
      return;
    isFavLoading = true;
    favicon = await getFavicon(DioBuilder.buildByBase(
        host: websiteHost,
        scheme: scheme,
        useDoH: useDoH,
        cookies: cookies.entries.map((e) => '${e.key}=${e.value}').join('; '),
        websiteType: websiteType,
        directLink: directLink,
        onlyHost: onlyHost));
    isFavLoading = false;
  }

  @action
  Future<void> checkWebsiteType() async {
    isCheckingType = true;
    isFirstCheckType = false;
    websiteType = WebsiteType.UNKNOWN;
    cancelToken = CancelToken();
    websiteType = await getWebsiteType(
      host: websiteHost,
      cancelToken: cancelToken!,
      directLink: directLink,
      onlyHost: onlyHost,
      cookies: cookies.entries.map((e) => '${e.key}=${e.value}').join('; '),
      scheme: scheme,
      useDoH: useDoH,
    );
    isCheckingType = false;
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
      await websiteDao.replace(website!.copyWith(
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
        getFavicon(DioBuilder.build(IWebsiteEntity.silent(table!)))
            .then((favicon) {
          mainStore.setWebsiteFavicon(id, favicon);
        });
    }
    await mainStore.updateList();
    return true;
  }
}
