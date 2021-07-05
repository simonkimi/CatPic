import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/ui/components/seelct_tile.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/ui/pages/website_manager/store/website_add_store.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

import '../../../i18n.dart';
import '../../../themes.dart';
import 'cookie_manager.dart';

class WebsiteAddGuide extends StatelessWidget {
  WebsiteAddGuide({
    Key? key,
    this.website,
  })  : store = WebsiteAddStore(website),
        super(key: key);

  final WebsiteTableData? website;

  static const route = 'WebsiteAddGuide';
  final WebsiteAddStore store;

  Future<bool> _back() async {
    if (!(store.cancelToken?.isCancelled ?? true)) store.cancelToken?.cancel();
    print(store.pageController.page!.toInt());
    if (store.pageController.page!.toInt() <= 0) {
      return true;
    }
    store.setCurrentPage(store.currentPage - 1);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final title = [
      I18n.of(context).home,
      I18n.of(context).network,
      I18n.of(context).scheme,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (_) => Text(
            title[store.currentPage],
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          onPressed: () async {
            if (await _back()) Navigator.of(context).pop();
          },
        ),
      ),
      body: Observer(
        builder: (_) => PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: store.pageController,
          children: [
            buildInputSite(context),
            buildNetworkSetting(context),
            buildCheckProtocol(context),
          ],
        ),
      ),
    );
  }

  Widget buildNetworkSetting(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          store.setCurrentPage(2);
          if (store.isFirstCheckType) {
            store.checkWebsiteType();
            store.requestFavicon();
          }
        },
        child: const Icon(
          Icons.arrow_forward_sharp,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text('HTTPS'),
            secondary: const Icon(Icons.http),
            subtitle: Text(I18n.of(context).scheme_https),
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
          ListTile(
            title: Text('Cookie (${store.cookies.length})'),
            leading: SvgPicture.asset(
              'assets/svg/cookie.svg',
              color:
                  isDarkMode(context) ? Colors.white : const Color(0xFF898989),
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              '您可能需要一些额外设置才能访问此网站, 否则请保持此页面设置不变',
              style: TextStyle(
                color: Theme.of(context).textTheme.subtitle2!.color,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildInputSite(BuildContext context) {
    final inputController = TextEditingController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final text = inputController.text;
          store.setWebsiteHost(text.getHost());
          if (store.websiteHost.isEmpty) {
            BotToast.showText(text: I18n.g.host_empty);
            return;
          }
          store.setCurrentPage(1);
        },
        child: const Icon(Icons.arrow_forward_sharp),
      ),
      body: WillPopScope(
        onWillPop: _back,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(hintText: 'example.com'),
                controller: inputController,
              ),
              const SizedBox(height: 10),
              Text(
                '请输入您想访问的网址',
                style: TextStyle(
                  color: Theme.of(context).textTheme.subtitle2!.color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckProtocol(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          store.isCheckingType || store.websiteType != WebsiteType.UNKNOWN
              ? FloatingActionButton(
                  onPressed: () {},
                  child: store.isCheckingType
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Icon(Icons.arrow_forward_sharp),
                )
              : null,
      body: WillPopScope(
        onWillPop: () async {
          return await _back();
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(50),
                child: ClipOval(
                  child: store.isFavLoading
                      ? const SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            strokeWidth: 8,
                          ),
                        )
                      : store.favicon != null && store.favicon!.isNotEmpty
                          ? Image.memory(
                              store.favicon!,
                              scale: 0.25,
                              width: 56,
                              height: 56,
                            )
                          : const SizedBox(
                              height: 56,
                              width: 56,
                            ),
                ),
              ),
              Text(
                store.isCheckingType
                    ? '请稍后'
                    : store.websiteType == WebsiteType.UNKNOWN
                        ? '错误'
                        : store.websiteType.string,
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                store.isCheckingType
                    ? '正在始别网站类型'
                    : store.websiteType == WebsiteType.UNKNOWN
                        ? '抱歉, 无法识别网站类型, 请手动指定'
                        : '已识别网站类型, 可进行下一步',
              ),
              const SizedBox(height: 50),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        store.cancelToken?.cancel();
                        final type = await showSelectDialog(
                            context: context,
                            items: [
                              SelectTileItem<int>(
                                  value: WebsiteType.GELBOORU,
                                  title: WebsiteType.GELBOORU.string),
                              SelectTileItem<int>(
                                  value: WebsiteType.MOEBOORU,
                                  title: WebsiteType.MOEBOORU.string),
                              SelectTileItem<int>(
                                  value: WebsiteType.DANBOORU,
                                  title: WebsiteType.DANBOORU.string),
                            ],
                            selectedValue: store.websiteType,
                            title: I18n.of(context).site_type);
                        if (type != null) {
                          store.setWebsiteType(type);
                        }
                      },
                      child: Text('手动指定')),
                  TextButton(
                      onPressed: () {
                        store.checkWebsiteType();
                      },
                      child: Text('重新检查'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
