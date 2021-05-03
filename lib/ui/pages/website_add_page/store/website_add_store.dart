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
  @observable
  String websiteName = '';
  @observable
  String websiteHost = '';
  @observable
  int scheme = WebsiteScheme.HTTPS.index;
  @observable
  int websiteType = WebsiteType.GELBOORU.index;
  @observable
  bool useDoH = false;
  @observable
  bool directLink = false;

  @observable
  String username = '';
  @observable
  String password = '';

  @action
  void setWebsiteName(String value) => websiteName = value;

  @action
  void setWebsiteHost(String value) => websiteHost = value;

  @action
  void setScheme(int value) => scheme = value;

  @action
  void setWebsiteType(int value) => websiteType = value;

  @action
  void setUseDoH(bool value) => useDoH = value;

  @action
  void setDirectLink(bool value) => directLink = value;

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
    final entity = WebsiteTableCompanion(
      host: Value(websiteHost),
      name: Value(websiteName),
      scheme: Value(scheme),
      useDoH: Value(useDoH),
      type: Value(websiteType),
      directLink: Value(directLink),
      username: username.isNotEmpty ? Value(username) : const Value(null),
      password: password.isNotEmpty ? Value(password) : const Value(null),
    );
    final id = await websiteDao.insert(entity);
    final table = await websiteDao.getById(id);
    mainStore.updateList();
    // 获取封面图片
    getFavicon(table!).then((favicon) {
      mainStore.setWebsiteFavicon(id, favicon);
    });
    return true;
  }
}
