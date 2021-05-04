import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:catpic/ui/components/text_input_tile.dart';
import 'package:catpic/ui/pages/website_add_page/store/website_add_store.dart';
import 'package:flutter/material.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:smart_select/smart_select.dart';
import 'package:smart_select/src/model/chosen.dart';

class WebsiteAddPage extends StatelessWidget {
  WebsiteAddPage({
    Key? key,
    this.website,
  })  : store = WebsiteAddStore(website),
        super(key: key);

  final WebsiteTableData? website;

  static const route = 'WebsiteAddPage';
  final WebsiteAddStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  SafeArea buildBody(BuildContext context) {
    return SafeArea(
      child: Observer(
        builder: (_) {
          return ListView(
            children: [
              ...buildBasicSetting(context),
              const Divider(),
              ...buildWebsiteSetting(context),
              const Divider(),
              ...buildAdvanceSetting(context),
              if (store.websiteType == WebsiteType.DANBOORU.index ||
                  store.websiteType == WebsiteType.MOEBOORU.index)
                const Divider(),
              if (store.websiteType == WebsiteType.DANBOORU.index ||
                  store.websiteType == WebsiteType.MOEBOORU.index)
                ...buildUserSetting(context),
            ],
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        I18n.of(context).add_website,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      leading: appBarBackButton(),
      actions: [
        // 右上角的确认按钮
        IconButton(
          icon: const Icon(
            Icons.check,
            size: 20,
          ),
          onPressed: () {
            // 保存网站后返回并且刷新页面
            store.saveWebsite().then((result) {
              if (result) {
                Navigator.pop(context);
              }
            });
          },
          tooltip: I18n.of(context).positive,
        )
      ],
    );
  }

  /// 构建基础设置
  List<Widget> buildBasicSetting(BuildContext context) {
    return [
      SummaryTile(I18n.of(context).basic_settings),
      TextInputTile(
        defaultValue: store.websiteName,
        title: Text(I18n.of(context).website_nickname),
        subtitle: Text(store.websiteName.isEmpty
            ? I18n.of(context).not_set
            : store.websiteName),
        leading: const SizedBox(),
        onChanged: (value) {
          store.setWebsiteName(value);
        },
      ),
    ];
  }

  /// 构建网络设置
  List<Widget> buildWebsiteSetting(BuildContext context) {
    return [
      SummaryTile(I18n.of(context).website_settings),
      TextInputTile(
        title: Text(I18n.of(context).host),
        subtitle: Text(store.websiteHost.isEmpty
            ? I18n.of(context).not_set
            : store.websiteHost),
        leading: const Icon(Icons.home),
        hintText: 'example.org',
        defaultValue: store.websiteHost,
        onChanged: (value) {
          store.setWebsiteHost(value.getHost());
        },
      ),
      SwitchListTile(
        title: Text(I18n.of(context).scheme),
        subtitle: Text(I18n.of(context).scheme_https),
        secondary: const Icon(Icons.http),
        value: store.scheme == WebsiteScheme.HTTPS.index,
        onChanged: (value) {
          store.setScheme(
              value ? WebsiteScheme.HTTPS.index : WebsiteScheme.HTTP.index);
          if (!value) {
            store.setDirectLink(false);
            store.setUseDoH(false);
          }
        },
      ),
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.search),
          );
        },
        modalType: S2ModalType.popupDialog,
        modalConfig: const S2ModalConfig(barrierColor: Colors.black54),
        selectedValue: WebsiteType.GELBOORU.index,
        onChange: (S2SingleSelected<int?> value) {
          store.setWebsiteType(value.value!);
        },
        title: I18n.of(context).site_type,
        choiceItems: [
          S2Choice(
            value: WebsiteType.GELBOORU.index,
            title: WebsiteType.GELBOORU.string,
          ),
          S2Choice(
            value: WebsiteType.MOEBOORU.index,
            title: WebsiteType.MOEBOORU.string,
          ),
          S2Choice(
            value: WebsiteType.DANBOORU.index,
            title: WebsiteType.DANBOORU.string,
          ),
        ],
      ),
    ];
  }

  /// 构建高级设置
  List<Widget> buildAdvanceSetting(BuildContext context) {
    return [
      SummaryTile(I18n.of(context).advanced_settings),
      SwitchListTile(
        title: Text(I18n.of(context).use_doh),
        subtitle: Text(I18n.of(context).use_doh_desc),
        value: store.useDoH,
        secondary: const Icon(Icons.list_alt),
        onChanged: (value) {
          store.setUseDoH(value);
          if (!value) {
            store.setDirectLink(false);
          }
        },
      ),
      SwitchListTile(
        title: Text(I18n.of(context).direct_link),
        subtitle: Text(I18n.of(context).direct_link_desc),
        secondary: const Icon(Icons.airplanemode_active_rounded),
        value: store.directLink,
        onChanged: (value) {
          if (value) {
            store.setDirectLink(true);
            store.setUseDoH(true);
          } else {
            store.setDirectLink(false);
          }
        },
      ),
    ];
  }

  String getPasswordTitle() {
    if (store.websiteType == WebsiteType.MOEBOORU.index)
      return I18n.g.password;
    else if (store.websiteType == WebsiteType.DANBOORU.index)
      return I18n.g.api_key;
    return 'Password';
  }

  List<Widget> buildUserSetting(BuildContext context) {
    return [
      SummaryTile(I18n.of(context).user_setting),
      TextInputTile(
        defaultValue: store.username,
        title: Text(I18n.of(context).username),
        subtitle: Text(
            store.username.isEmpty ? I18n.of(context).not_set : store.username),
        leading: const SizedBox(),
        onChanged: (value) {
          store.setUsername(value);
        },
      ),
      TextInputTile(
        defaultValue: store.password,
        title: Text(getPasswordTitle()),
        subtitle: Text(
            store.password.isEmpty ? I18n.of(context).not_set : store.password),
        leading: const SizedBox(),
        onChanged: (value) {
          store.setPassword(value);
        },
      ),
    ];
  }
}
