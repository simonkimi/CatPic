import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/host_entity.dart';
import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/generated/l10n.dart';
import 'package:catpic/network/misc/misc_network.dart';
import 'package:catpic/ui/components/setting/summary_tile.dart';
import 'package:catpic/ui/components/setting/text_input_tile.dart';
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
    websiteName = '';
    websiteHost = '';
    scheme = WebsiteScheme.HTTPS.index;
    websiteType = WebsiteType.GELBOORU.index;
    useHostList = false;
    domainFronting = false;
    extendLayout = false;
    displayOriginal = false;
    trustHost = "";
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
          Divider(),
          ...buildWebsiteSetting(),
          Divider(),
          ...buildDisplaySetting(),
          Divider(),
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
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          EventBusUtil().bus.fire(EventSiteChange());
          Navigator.pop(context);
        },
        tooltip: S.of(context).back,
      ),
      actions: [
        // 右上角的确认按钮
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            // 保存网站后返回并且刷新页面
            saveWebsite().then((result) {
              if (result) {
                EventBusUtil().bus.fire(EventSiteChange());
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
        leading: SizedBox(),
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
        leading: Icon(Icons.home),
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
        secondary: Icon(Icons.http),
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
              child: Text('EHentai'), value: WebsiteType.EHENTAI.index),
          PopupMenuItem(
              child: Text('Gelbooru'), value: WebsiteType.GELBOORU.index),
          PopupMenuItem(
              child: Text('Moebooru'), value: WebsiteType.MOEBOORU.index),
          PopupMenuItem(
              child: Text('Danbooru'), value: WebsiteType.DANBOORU.index),
        ],
        child: ListTile(
          title: Text(S.of(context).site_type),
          subtitle: Text(websiteTypeName[websiteType]),
          leading: Icon(Icons.search),
        ),
        onSelected: (value) {
          setState(() {
            websiteType = value;
          });
        },
      ),
    ];
  }

  /// 构建显示设置
  List<Widget> buildDisplaySetting() {
    return [
      SummaryTile(S.of(context).display_setting),
      SwitchListTile(
        value: extendLayout,
        title: Text(S.of(context).use_extend_layout),
        subtitle: Text(extendLayout
            ? S.of(context).extend_layout
            : S.of(context).compact_layout),
        secondary: Icon(Icons.art_track),
        onChanged: (value) {
          setState(() {
            extendLayout = value;
          });
        },
      ),
      SwitchListTile(
        title: Text(S.of(context).display_original),
        value: displayOriginal,
        secondary: Icon(Icons.filter),
        onChanged: (value) {
          setState(() {
            displayOriginal = value;
          });
        },
      )
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
        secondary: Icon(Icons.list_alt),
        onChanged: (value) {
          setHostList(value);
        },
      ),
      SwitchListTile(
        title: Text(S.of(context).domain_fronting),
        subtitle: Text(S.of(context).domain_fronting_desc),
        secondary: Icon(Icons.airplanemode_active_rounded),
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

  bool extendLayout;
  bool displayOriginal;

  /// 当要开启自定义host的时候进行请求真实ip
  void setHostList(bool targetValue) {
    if (targetValue) {
      var host = getHost(websiteHost);
      if (host.isNotEmpty) {
        var cancelFunc = BotToast.showLoading();
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
    var websiteDao = DatabaseHelper().websiteDao;
    var entity = WebsiteEntity(
      cookies: '',
      displayOriginal: displayOriginal,
      extendLayout: extendLayout,
      host: websiteHost,
      name: websiteName,
      scheme: scheme,
      useHostList: useHostList,
      type: websiteType,
      favicon: Uint8List.fromList([]),
    );
    var id = await websiteDao.addSite(entity);
    
    // 保存自定义host
    if (useHostList) {
      var hostDao = DatabaseHelper().hostDao;
      var existHost = await hostDao.getByHost(websiteHost);
      if (existHost != null) {
        await hostDao.removeHost([existHost]);
      }

      var hostEntity = HostEntity(
        host: websiteHost,
        ip: trustHost,
        sni: domainFronting
      );
      hostDao.addHost(hostEntity);
    }

    // 获取封面图片
    getFavicon(entity).then((favicon) {
      websiteDao.getById(id).then((e) {
        e.favicon = favicon;
        print("下载Favicon完成, 长度: ${e.favicon.length}");
        websiteDao.updateSite(e).then((value) {
          EventBusUtil().bus.fire(EventSiteChange());
        });
      });
    });
    return true;
  }
}
