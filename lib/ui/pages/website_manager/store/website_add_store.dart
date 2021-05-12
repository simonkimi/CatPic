import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:mobx/mobx.dart';

import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:moor/moor.dart';

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
        username = website?.username ?? '',
        password = website?.password ?? '',
        onlyHost = website?.onlyHost ?? false;

  WebsiteTableData? website;

  @observable
  late String websiteName;
  @observable
  late String websiteHost;
  @observable
  late int scheme;
  @observable
  late int websiteType;
  @observable
  late bool useDoH;
  @observable
  late bool directLink;
  @observable
  late bool onlyHost;
  @observable
  String username;
  @observable
  String password;

  @action
  void setWebsiteName(String value) => websiteName = value;

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
    final websiteDao = DatabaseHelper().websiteDao;
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
      ));
    } else {
      final entity = WebsiteTableCompanion(
        host: Value(websiteHost),
        name: Value(websiteName),
        scheme: Value(scheme),
        useDoH: Value(useDoH),
        type: Value(websiteType),
        directLink: Value(directLink),
        onlyHost: Value(onlyHost),
        username: username.isNotEmpty ? Value(username) : const Value(null),
        password: password.isNotEmpty ? Value(password) : const Value(null),
      );
      final id = await websiteDao.insert(entity);
      final table = await websiteDao.getById(id);
      getFavicon(table!).then((favicon) {
        mainStore.setWebsiteFavicon(id, favicon);
      });
    }
    mainStore.updateList();
    return true;
  }
}
