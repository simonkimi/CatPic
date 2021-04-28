import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/ui/pages/download_page/android_download.dart';
import 'package:catpic/ui/pages/download_page/download_manager.dart';
import 'package:catpic/ui/pages/download_page/store/download_store.dart';
import 'package:catpic/ui/pages/search_page/search_page.dart';
import 'package:catpic/ui/pages/setting_page/setting_page.dart';
import 'package:catpic/ui/pages/website_add_page/website_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sp_util/sp_util.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:catpic/themes.dart' as theme;

import 'data/store/main/main_store.dart';

final downloadStore = DownloadStore();
final mainStore = MainStore();
final settingStore = SettingStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  await settingStore.init();
  await mainStore.init();
  downloadStore.startDownload();
  runApp(CatPicApp());
}

class AppNavigator {
  factory AppNavigator() => _appNavigator;

  AppNavigator._();

  static final AppNavigator _appNavigator = AppNavigator._();
  final GlobalKey<NavigatorState> _key = GlobalKey(debugLabel: 'navigate_key');

  GlobalKey<NavigatorState> get key => _key;

  BuildContext get context => _key.currentState!.context;
}

class CatPicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatPic',
      debugShowCheckedModeBanner: false,
      theme: theme.blueTheme,
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
  }
}
