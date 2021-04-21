import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:catpic/main.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:catpic/ui/components/text_input_tile.dart';
import 'package:flutter/material.dart';
import 'package:catpic/utils/utils.dart';

class WebsiteAddPage extends StatefulWidget {
  static const route = 'DownloadManagerPage';

  @override
  _WebsiteAddPageState createState() => _WebsiteAddPageState();
}

class _WebsiteAddPageState extends State<WebsiteAddPage>
    with _WebsiteAddPageMixin {
  @override
  void initState() {
    super.initState();
    debugPrint('WebsiteAddPage initState');
    websiteName = '';
    websiteHost = '';
    scheme = WebsiteScheme.HTTPS.index;
    websiteType = WebsiteType.GELBOORU.index;
    useDoH = false;
    directLink = false;
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('WebsiteAddPage dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  SafeArea buildBody() {
    return SafeArea(
      child: ListView(
        children: [
          ...buildBasicSetting(),
          const Divider(),
          ...buildWebsiteSetting(),
          const Divider(),
          ...buildAdvanceSetting(),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        I18n.of(context).add_website,
        style: const TextStyle(fontSize: 18),
      ),
      // 左上角的返回按钮
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: I18n.of(context).back,
      ),
      actions: [
        // 右上角的确认按钮
        IconButton(
          icon: const Icon(
            Icons.check,
            size: 20,
          ),
          onPressed: () {
            // 保存网站后返回并且刷新页面
            saveWebsite().then((result) {
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
  List<Widget> buildBasicSetting() {
    return [
      SummaryTile(I18n.of(context).basic_settings),
      TextInputTile(
        defaultValue: websiteName,
        title: Text(I18n.of(context).website_nickname),
        subtitle:
            Text(websiteName.isEmpty ? I18n.of(context).not_set : websiteName),
        leading: const SizedBox(),
        onChanged: (value) {
          setState(() {
            websiteName = value;
          });
        },
      ),
    ];
  }

  /// 构建网络设置
  List<Widget> buildWebsiteSetting() {
    return [
      SummaryTile(I18n.of(context).website_settings),
      TextInputTile(
        title: Text(I18n.of(context).host),
        subtitle:
            Text(websiteHost.isEmpty ? I18n.of(context).not_set : websiteHost),
        leading: const Icon(Icons.home),
        hintText: 'example.org',
        defaultValue: websiteHost,
        onChanged: (value) {
          setState(() {
            websiteHost = value.getHost();
          });
        },
      ),
      SwitchListTile(
        title: Text(I18n.of(context).scheme),
        subtitle: Text(I18n.of(context).scheme_https),
        secondary: const Icon(Icons.http),
        value: scheme == WebsiteScheme.HTTPS.index,
        onChanged: (value) {
          setState(() {
            scheme =
                value ? WebsiteScheme.HTTPS.index : WebsiteScheme.HTTP.index;
          });
        },
      ),
      PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
              child: const Text('EHentai'), value: WebsiteType.EHENTAI.index),
          PopupMenuItem(
              child: const Text('Gelbooru'), value: WebsiteType.GELBOORU.index),
          PopupMenuItem(
              child: const Text('Moebooru'), value: WebsiteType.MOEBOORU.index),
          PopupMenuItem(
              child: const Text('Danbooru'), value: WebsiteType.DANBOORU.index),
        ],
        child: ListTile(
          title: Text(I18n.of(context).site_type),
          subtitle: Text(websiteTypeName[websiteType]!),
          leading: const Icon(Icons.search),
        ),
        onSelected: (int value) {
          setState(() {
            websiteType = value;
          });
        },
      ),
    ];
  }

  /// 构建高级设置
  List<Widget> buildAdvanceSetting() {
    return [
      SummaryTile(I18n.of(context).advanced_settings),
      SwitchListTile(
        title: Text(I18n.of(context).use_doh),
        subtitle: Text(I18n.of(context).use_doh_desc),
        value: useDoH,
        secondary: const Icon(Icons.list_alt),
        onChanged: (value) {
          setState(() {
            useDoH = value;
          });
        },
      ),
      SwitchListTile(
        title: Text(I18n.of(context).direct_link),
        subtitle: Text(I18n.of(context).direct_link_desc),
        secondary: const Icon(Icons.airplanemode_active_rounded),
        value: directLink,
        onChanged: (value) {
          setState(() {
            setState(() {
              if (value) {
                directLink = true;
                useDoH = true;
              } else {
                directLink = false;
              }
            });
          });
        },
      ),
    ];
  }
}

mixin _WebsiteAddPageMixin<T extends StatefulWidget> on State<T> {
  late String websiteName;
  late String websiteHost;
  late int scheme;
  late int websiteType;
  late bool directLink;
  late bool useDoH;

  /// 保存网站
  Future<bool> saveWebsite() async {
    if (websiteHost.isEmpty) {
      BotToast.showText(text: I18n.of(context).host_empty);
      return false;
    }
    if (websiteName.isEmpty) {
      websiteName = websiteHost;
    }

    // 保存网站
    final websiteDao = DatabaseHelper().websiteDao;
    final entity = WebsiteTableCompanion.insert(
      host: websiteHost,
      name: websiteName,
      scheme: scheme,
      useDoH: useDoH,
      type: websiteType,
      directLink: directLink,
    );
    final id = await websiteDao.insert(entity);

    final table = await websiteDao.getById(id);
    // 获取封面图片
    getFavicon(table!).then((favicon) {
      mainStore.setWebsiteFavicon(id, favicon);
    });
    return true;
  }
}
