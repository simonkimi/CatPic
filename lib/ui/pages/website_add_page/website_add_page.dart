import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/generated/l10n.dart';
import 'package:catpic/network/misc/misc_network.dart';
import 'package:catpic/ui/components/setting/summary_tile.dart';
import 'package:catpic/ui/components/setting/text_input_tile.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:flutter/material.dart';

class WebsiteAddPage extends StatefulWidget {
  static String routeName = 'WebsiteAddPage';

  @override
  _WebsiteAddPageState createState() => _WebsiteAddPageState();
}

class _WebsiteAddPageState extends State<WebsiteAddPage> {
  String websiteName;
  String websiteHost;
  int protocol;
  int websiteType;
  String trustHost;
  bool domainFronting;

  bool extendLayout;
  bool displayOriginal;

  @override
  void initState() {
    super.initState();
    websiteName = '';
    websiteHost = '';
    protocol = WebsiteProtocol.HTTPS.index;
    websiteType = WebsiteType.GELBOORU.index;
    trustHost = '';
    domainFronting = false;
    extendLayout = false;
    displayOriginal = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).add_website),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            EventBusUtil().bus.fire(EventSiteChange());
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                var cancelFunc = BotToast.showLoading();
                saveWebsite(context).then((_) {
                  cancelFunc();
                  EventBusUtil().bus.fire(EventSiteChange());
                  Navigator.pop(context);
                });
              })
        ],
      ),
      body: SafeArea(
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
      ),
    );
  }

  Future<void> saveWebsite(BuildContext context) async {
    var websiteDao = DatabaseHelper().websiteDao;
    var entity = WebsiteEntity(
      cookies: '',
      displayOriginal: displayOriginal,
      extendLayout: extendLayout,
      host: websiteHost,
      name: websiteName,
      protocol: protocol,
      trustHost: trustHost,
      type: websiteType,
      useDomainFronting: domainFronting,
      favicon: Uint8List.fromList([]),
    );
    var id = await websiteDao.addSite(entity);

    getFavicon(
      context: context,
      host: websiteHost,
      protocol: protocol,
      trustHost: trustHost,
      sni: domainFronting,
    ).then((favicon) {
      websiteDao.getById(id).then((e) {
        e.favicon = favicon;
        websiteDao.updateSite(e);
      });
    });
  }

  List<Widget> buildBasicSetting() {
    return [
      SummaryTile(S.of(context).basic_settings),
      TextInputTile(
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

  List<Widget> buildWebsiteSetting() {
    return [
      SummaryTile(S.of(context).website_settings),
      TextInputTile(
        title: Text(S.of(context).host),
        subtitle:
            Text(websiteHost.isEmpty ? S.of(context).not_set : websiteHost),
        leading: Icon(Icons.home),
        hintText: 'example.org',
        onChanged: (value) {
          var v = value;
          if (v.startsWith('https://')) {
            v = v.substring('https://'.length, v.length);
          }
          if (v.startsWith('http://')) {
            v = v.substring('http://'.length, v.length);
          }
          if (v.endsWith('/')) {
            v = v.substring(0, v.length - 1);
          }
          setState(() {
            websiteHost = v;
          });
        },
      ),
      SwitchListTile(
        title: Text(S.of(context).protocol),
        subtitle: Text(S.of(context).protocol_https),
        secondary: Icon(Icons.http),
        value: protocol == WebsiteProtocol.HTTPS.index,
        onChanged: (value) {
          setState(() {
            protocol = value
                ? WebsiteProtocol.HTTPS.index
                : WebsiteProtocol.HTTP.index;
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

  List<Widget> buildAdvanceSetting() {
    return [
      SummaryTile(S.of(context).advanced_settings),
      TextInputTile(
        leading: Icon(Icons.flag),
        title: Text(S.of(context).trusted_host),
        subtitle: Text(
            trustHost.isEmpty ? S.of(context).trusted_host_desc : trustHost),
        onChanged: (value) {
          setState(() {
            trustHost = value;
          });
        },
      ),
      ListTile(
        leading: Icon(Icons.autorenew_sharp),
        title: Text(S.of(context).trusted_host_auto),
        onTap: () {
          if (websiteHost.isNotEmpty) {
            var cancelFunc = BotToast.showLoading();
            getTrustHost(websiteHost).then((value) {
              cancelFunc();
              if (value.isNotEmpty) {
                setState(() {
                  trustHost = value;
                });
              } else {
                BotToast.showText(text: S.of(context).trusted_host_auto_failed);
              }
            });
          }
        },
      ),
      SwitchListTile(
        title: Text(S.of(context).domain_fronting),
        subtitle: Text(S.of(context).domain_fronting_desc),
        secondary: Icon(Icons.airplanemode_active_rounded),
        value: domainFronting,
        onChanged: (value) {
          setState(() {
            domainFronting = value;
          });
        },
      ),
    ];
  }
}
