import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/sp_helper.dart';
import 'package:catpic/ui/pages/search_page/search_page.dart';
import 'package:catpic/ui/store/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:catpic/themes/themes.dart' as theme;

import 'data/database/database_helper.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().init();
  await SPHelper().init();
  await mainStore.init();
  runApp(CatPicApp());
}

class CatPicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatPic',
      debugShowCheckedModeBanner: false,
      theme: theme.purpleTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        RefreshLocalizations.delegate,
        S.delegate
      ],
      home: SearchPage(),
      builder: BotToastInit(),
      supportedLocales: const [
        Locale('en'),
        Locale('zh', 'CN'),
      ],
    );
  }
}
