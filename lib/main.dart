import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/themes.dart' as theme;
import 'package:catpic/ui/pages/website_add_page/website_add_page.dart';
import 'package:catpic/ui/pages/website_manager/website_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/database/database_helper.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initDataBase();
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
      home: WebsiteManagerPage(),
      routes: {
        WebsiteManagerPage.routeName: (context) => WebsiteManagerPage(),
        WebsiteAddPage.routeName: (context) => WebsiteAddPage(),
      },
    );
  }
}
