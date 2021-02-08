import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/sp_helper.dart';
import 'package:catpic/router.dart';
import 'package:catpic/themes.dart' as theme;
import 'package:catpic/ui/pages/search_page/search_page.dart';
import 'package:catpic/ui/store/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'data/database/database_helper.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().init();
  await SPHelper().init();
  await mainStore.init();
  runApp(MyApp());
  return;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final delegate = MyRouteDelegate(
        home: CatPicPage(
          key: const ValueKey('SearchPage_index'),
          name: 'SearchPage_index',
          builder: (ctx) => SearchPage(),),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              settings: settings,
              builder: (ctx) => SearchPage()
          );
        }
    );
    return MaterialApp.router(
      title: 'CatPic',
      debugShowCheckedModeBanner: false,
      theme: theme.blueTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        RefreshLocalizations.delegate,
        S.delegate
      ],
      builder: BotToastInit(),
      routerDelegate: delegate,
      routeInformationParser: MyRouteParser(),
      supportedLocales: const [
        Locale('en'),
        Locale('zh', 'CN'),
      ],
    );
  }
}
