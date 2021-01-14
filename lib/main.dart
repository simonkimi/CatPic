import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/sp_helper.dart';
import 'package:catpic/themes.dart' as theme;
import 'package:catpic/ui/pages/host_manager_page/host_manager_page.dart';
import 'package:catpic/ui/pages/main_page/main_page.dart';
import 'package:catpic/ui/pages/main_page/store/main_store.dart';
import 'package:catpic/ui/pages/website_add_page/website_add_page.dart';
import 'package:catpic/ui/pages/website_manager/website_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/database/database_helper.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().init();
  await SPHelper().init();
  await mainStore.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatPic',
      debugShowCheckedModeBanner: false,
      theme: theme.blueTheme,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      supportedLocales: [
        Locale('en'),
        Locale('zh', 'CN'),
      ],
      home: HostManagerPage(),
      routes: {
        WebsiteManagerPage.routeName: (context) => WebsiteManagerPage(),
        WebsiteAddPage.routeName: (context) => WebsiteAddPage(),
        MainPage.routeName: (context) => MainPage(),
        HostManagerPage.routeName: (context) => HostManagerPage()
      },
    );
  }
}
