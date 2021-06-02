import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/seelct_tile.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:catpic/ui/components/text_input_tile.dart';
import 'package:catpic/ui/pages/website_manager/cookie_manager.dart';
import 'package:catpic/ui/pages/website_manager/store/website_add_store.dart';
import 'package:flutter/material.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../themes.dart';

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
              const Divider(),
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
        IconButton(
          onPressed: () {
            store.saveWebsite().then((result) {
              if (result) {
                Navigator.of(context).pop();
              }
            });
          },
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
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
      SelectTile<int>(
        leading: const Icon(Icons.search),
        selectedValue: store.websiteType,
        onChange: (value) {
          store.setWebsiteType(value);
        },
        title: I18n.of(context).site_type,
        items: [
          SelectTileItem(
            value: WebsiteType.GELBOORU.index,
            title: WebsiteType.GELBOORU.string,
          ),
          SelectTileItem(
            value: WebsiteType.MOEBOORU.index,
            title: WebsiteType.MOEBOORU.string,
          ),
          SelectTileItem(
            value: WebsiteType.DANBOORU.index,
            title: WebsiteType.DANBOORU.string,
          ),
          SelectTileItem(
            value: WebsiteType.EHENTAI.index,
            title: WebsiteType.EHENTAI.string,
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
      if (store.useDoH)
        SwitchListTile(
          title: Text(I18n.of(context).only_host),
          value: store.onlyHost,
          secondary: const Icon(Icons.location_on_outlined),
          onChanged: (value) {
            store.setOnlyHost(value);
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
      if (store.websiteType == WebsiteType.DANBOORU.index ||
          store.websiteType == WebsiteType.MOEBOORU.index)
        TextInputTile(
          defaultValue: store.username,
          title: Text(I18n.of(context).username),
          subtitle: Text(store.username.isEmpty
              ? I18n.of(context).not_set
              : store.username),
          leading: const SizedBox(),
          onChanged: (value) {
            store.setUsername(value);
          },
        ),
      if (store.websiteType == WebsiteType.DANBOORU.index ||
          store.websiteType == WebsiteType.MOEBOORU.index)
        TextInputTile(
          defaultValue: store.password,
          title: Text(getPasswordTitle()),
          subtitle: Text(store.password.isEmpty
              ? I18n.of(context).not_set
              : store.password),
          leading: const SizedBox(),
          onChanged: (value) {
            store.setPassword(value);
          },
        ),
      ListTile(
        title: Text('Cookie (${store.cookies.length})'),
        leading: SvgPicture.asset(
          'assets/svg/cookie.svg',
          color: isDarkMode(context) ? Colors.white : const Color(0xFF898989),
          height: 24,
          width: 24,
        ),
        subtitle: Text(I18n.of(context).cookie_desc),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CookieManagerPage(
              store: store,
            ),
          ));
        },
      ),
    ];
  }
}
