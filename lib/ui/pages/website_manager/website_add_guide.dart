import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/ui/components/seelct_tile.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:catpic/ui/components/text_input_tile.dart';
import 'package:flutter/material.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/ui/pages/website_manager/store/website_add_store.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

import '../../../i18n.dart';
import '../../../themes.dart';
import 'cookie_manager.dart';

class GuidePage {
  static const int URL = 0;
  static const int NETWORK = 1;
  static const int SCHEME = 2;
  static const int LOGIN = 3;
  static const int NICKNAME = 4;
}

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
      I18n.of(context).login,
      I18n.of(context).nickname,
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
            buildLoginPage(context),
            buildInputNickName(context),
          ],
        ),
      ),
    );
  }

  Widget buildNetworkSetting(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          store.setCurrentPage(GuidePage.SCHEME);
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
              I18n.of(context).extra_network_desc,
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
    final inputController = TextEditingController(text: store.websiteHost);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final text = inputController.text;
          store.setWebsiteHost(text.getHost());
          if (store.websiteHost.isEmpty) {
            BotToast.showText(text: I18n.g.host_empty);
            return;
          }
          store.setCurrentPage(GuidePage.NETWORK);
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
                I18n.of(context).input_website_desc,
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
                  onPressed: () {
                    if (store.websiteType != WebsiteType.UNKNOWN) {
                      if (store.websiteType != WebsiteType.EHENTAI &&
                          store.websiteType != WebsiteType.GELBOORU)
                        store.setCurrentPage(GuidePage.LOGIN);
                      else
                        store.setCurrentPage(GuidePage.NICKNAME);
                    }
                  },
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
                    ? I18n.of(context).please_wait
                    : store.websiteType == WebsiteType.UNKNOWN
                        ? I18n.of(context).error
                        : store.websiteType.string,
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                store.isCheckingType
                    ? I18n.of(context).check_website_type_desc
                    : store.websiteType == WebsiteType.UNKNOWN
                        ? I18n.of(context).check_website_type_fail_desc
                        : I18n.of(context).check_website_type_success_desc,
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
                    child: Text(I18n.of(context).check_by_hand),
                  ),
                  TextButton(
                    onPressed: () {
                      store.checkWebsiteType();
                    },
                    child: Text(I18n.of(context).recheck),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginPage(BuildContext context) {
    String getPasswordTitle() {
      if (store.websiteType == WebsiteType.MOEBOORU)
        return I18n.of(context).password;
      else if (store.websiteType == WebsiteType.DANBOORU)
        return I18n.of(context).api_key;
      return 'Password';
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_sharp),
        onPressed: () {
          store.setCurrentPage(GuidePage.NICKNAME);
        },
      ),
      body: ListView(
        children: [
          if (store.websiteType == WebsiteType.DANBOORU ||
              store.websiteType == WebsiteType.MOEBOORU)
            TextInputTile(
              defaultValue: store.username,
              title: Text(I18n.of(context).username),
              subtitle: Text(store.username.isEmpty
                  ? I18n.of(context).not_set
                  : store.username),
              onChanged: (value) {
                store.setUsername(value);
              },
            ),
          if (store.websiteType == WebsiteType.DANBOORU ||
              store.websiteType == WebsiteType.MOEBOORU)
            TextInputTile(
              defaultValue: store.password,
              title: Text(getPasswordTitle()),
              subtitle: Text(store.password.isEmpty
                  ? I18n.of(context).not_set
                  : store.password),
              onChanged: (value) {
                store.setPassword(value);
              },
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '一些特殊功能可能要求您登录, 否则您可以跳过此步骤',
              style: TextStyle(
                color: Theme.of(context).textTheme.subtitle2!.color,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildInputNickName(BuildContext context) {
    final inputController = TextEditingController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final text = inputController.text;
          if (text.isEmpty)
            store.setWebsiteName(store.websiteHost);
          else
            store.setWebsiteName(text);
          store.saveWebsite();
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.check),
      ),
      body: WillPopScope(
        onWillPop: _back,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(hintText: store.websiteHost),
                controller: inputController,
              ),
              const SizedBox(height: 10),
              Text(
                '最后一步! 输入此网站昵称! (默认为host)',
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
}
