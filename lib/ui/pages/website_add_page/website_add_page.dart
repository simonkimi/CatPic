import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/host_entity.dart';
import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/generated/l10n.dart';
import 'package:catpic/network/misc/misc_network.dart';
import 'package:catpic/ui/components/setting/summary_tile.dart';
import 'package:catpic/ui/components/setting/text_input_tile.dart';
import 'package:catpic/ui/store/main/main_store.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:catpic/utils/misc_util.dart';
import 'package:flutter/material.dart';

class WebsiteAddPage extends StatefulWidget {
  static String routeName = 'WebsiteAddPage';

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
    useHostList = false;
    domainFronting = false;
    trustHost = '';
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
      title: Text(S.of(context).add_website),
      // 左上角的返回按钮
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          EventBusUtil().bus.fire(EventSiteListChange());
          Navigator.pop(context);
        },
        tooltip: S.of(context).back,
      ),
      actions: [
        // 右上角的确认按钮
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            // 保存网站后返回并且刷新页面
            saveWebsite().then((result) {
              if (result) {
                EventBusUtil().bus.fire(EventSiteListChange());
                Navigator.pop(context);
              }
            });
          },
          tooltip: S.of(context).confirm,
        )
      ],
    );
  }

  /// 构建基础设置
  List<Widget> buildBasicSetting() {
    return [
      SummaryTile(S.of(context).basic_settings),
      TextInputTile(
        defaultValue: websiteName,
        title: Text(S.of(context).website_nickname),
        subtitle:
            Text(websiteName.isEmpty ? S.of(context).not_set : websiteName),
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
      SummaryTile(S.of(context).website_settings),
      TextInputTile(
        title: Text(S.of(context).host),
        subtitle:
            Text(websiteHost.isEmpty ? S.of(context).not_set : websiteHost),
        leading: const Icon(Icons.home),
        hintText: 'example.org',
        defaultValue: websiteHost,
        onChanged: (value) {
          setState(() {
            websiteHost = getHost(value);
          });
        },
      ),
      SwitchListTile(
        title: Text(S.of(context).scheme),
        subtitle: Text(S.of(context).scheme_https),
        secondary: const Icon(Icons.http),
        value: scheme == WebsiteScheme.HTTPS.index,
        onChanged: (value) {
          setState(() {
            scheme = value
                ? WebsiteScheme.HTTPS.index
                : WebsiteScheme.HTTP.index;
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
          title: Text(S.of(context).site_type),
          subtitle: Text(websiteTypeName[websiteType]),
          leading: const Icon(Icons.search),
        ),
        onSelected: (value) {
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
      SummaryTile(S.of(context).advanced_settings),
      SwitchListTile(
        title: Text(S.of(context).use_host_list),
        subtitle:
            Text(useHostList ? trustHost : S.of(context).use_host_list_desc),
        value: useHostList,
        secondary: const Icon(Icons.list_alt),
        onChanged: (value) {
          setHostList(value);
        },
      ),
      SwitchListTile(
        title: Text(S.of(context).domain_fronting),
        subtitle: Text(S.of(context).domain_fronting_desc),
        secondary: const Icon(Icons.airplanemode_active_rounded),
        value: domainFronting,
        onChanged: (value) {
          setState(() {
            if (!value) {
              domainFronting = value;
            } else if (value && useHostList) {
              domainFronting = value;
            } else {
              BotToast.showText(text: S.of(context).turn_on_host);
            }
          });
        },
      ),
    ];
  }
}

mixin _WebsiteAddPageMixin<T extends StatefulWidget> on State<T> {
  String websiteName;
  String websiteHost;
  int scheme;
  int websiteType;
  bool domainFronting;
  bool useHostList;

  String trustHost;

  /// 当要开启自定义host的时候进行请求真实ip
  void setHostList(bool targetValue) async {
    if (targetValue) {
      final host = getHost(websiteHost);
      if (host.isNotEmpty) {
        // 判断是否已经存在
        final hostDao = DatabaseHelper().hostDao;
        final hostExist = await hostDao.getByHost(host);
        if (hostExist != null) {
          setState(() {
            useHostList = true;
            trustHost = hostExist.ip;
          });
        } else {
          final cancelFunc = BotToast.showLoading();
          getTrustHost(host).then((host) {
            cancelFunc();
            if (host.isNotEmpty) {
              setState(() {
                useHostList = true;
                trustHost = host;
              });
            } else {
              BotToast.showText(text: S.of(context).trusted_host_auto_failed);
            }
          });
        }
      } else {
        BotToast.showText(text: S.of(context).host_empty);
      }
    } else {
      setState(() {
        useHostList = false;
        domainFronting = false;
      });
    }
  }

  /// 保存网站
  Future<bool> saveWebsite() async {
    if (websiteHost.isEmpty) {
      BotToast.showText(text: S.of(context).host_empty);
      return false;
    }
    if (websiteName.isEmpty) {
      websiteName = websiteHost;
    }
    
    // 保存网站
    final websiteDao = DatabaseHelper().websiteDao;
    final entity = WebsiteEntity(
      cookies: '',
      host: websiteHost,
      name: websiteName,
      scheme: scheme,
      useHostList: useHostList,
      type: websiteType,
      favicon: Uint8List.fromList([]),
    );
    final id = await websiteDao.addSite(entity);
    
    // 保存自定义host
    if (useHostList) {
      final hostDao = DatabaseHelper().hostDao;
      final existHost = await hostDao.getByHost(websiteHost);
      if (existHost != null) {
        await hostDao.removeHost([existHost]);
      }

      final hostEntity = HostEntity(
        host: websiteHost,
        ip: trustHost,
        sni: domainFronting
      );
      hostDao.addHost(hostEntity);
    }

    // 获取封面图片
    getFavicon(entity).then((favicon) {
      mainStore.setWebsiteFavicon(id, favicon);
    });
    return true;
  }


}
