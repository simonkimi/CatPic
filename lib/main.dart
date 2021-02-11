import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/sp_helper.dart';
import 'package:catpic/router/catpic_page.dart';
import 'package:catpic/router/route_delegate.dart';
import 'package:catpic/router/router_parser.dart';
import 'package:catpic/test/test_booru.dart';
import 'package:catpic/themes.dart' as theme;
import 'package:catpic/ui/pages/image_view_page/image_view_page.dart';
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
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CatPic',
      debugShowCheckedModeBanner: false,
      theme: theme.purpleTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        RefreshLocalizations.delegate,
        S.delegate
      ],
      builder: BotToastInit(),
      routerDelegate: MyRouteDelegate(
          home: CatPicPage(
            key: const ValueKey('SearchPage_index'),
            name: 'SearchPage_index',
            body: SearchPage(),
          ),
          onGenerateRoute: (RouteSettings settings) {
            print('onGenerateRoute');
            return MaterialPageRoute(
              settings: settings,
              builder: (ctx) => SearchPage(),
            );
          }),
      routeInformationParser: MyRouteParser(),
      supportedLocales: const [
        Locale('en'),
        Locale('zh', 'CN'),
      ],
    );
  }
}
