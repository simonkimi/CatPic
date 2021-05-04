import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/ui/pages/download_page/android_download.dart';
import 'package:catpic/ui/pages/download_page/download_manager.dart';
import 'package:catpic/data/store/download/download_store.dart';
import 'package:catpic/ui/pages/search_page/search_page.dart';
import 'package:catpic/ui/pages/setting_page/setting_page.dart';
import 'package:catpic/ui/pages/website_add_page/website_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sp_util/sp_util.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:catpic/themes.dart' as theme;

import 'data/store/main/main_store.dart';
import 'navigator.dart';

final downloadStore = DownloadStore();
final mainStore = MainStore();
final settingStore = SettingStore();

void main() {
  runApp(const SplashPage());
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  Future<void> loading() async {
    await SpUtil.getInstance();
    await settingStore.init();
    await mainStore.init();
    downloadStore.startDownload();
  }

  Widget buildHello(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'CatPic',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: FutureBuilder<void>(
        future: loading(),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: snapshot.connectionState == ConnectionState.done
                ? CatPicApp()
                : buildHello(context),
          );
        },
      ),
    );
  }
}

class CatPicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return MaterialApp(
        title: 'CatPic',
        debugShowCheckedModeBanner: false,
        theme: theme.Themes.of(settingStore.theme),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          RefreshLocalizations.delegate,
          AppLocalizations.delegate
        ],
        navigatorKey: AppNavigator().key,
        home: const SearchPage(),
        builder: BotToastInit(),
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          DownloadManagerPage.route: (ctx) => DownloadManagerPage(),
          AndroidDownloadPage.route: (ctx) => AndroidDownloadPage(),
          SettingPage.route: (ctx) => SettingPage(),
          WebsiteAddPage.route: (ctx) => WebsiteAddPage(),
        },
      );
    });
  }
}
