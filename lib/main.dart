import 'package:catpic/themes.dart' as theme;
import 'package:catpic/ui/pages/main_page/main_page.dart';
import 'package:catpic/ui/pages/website_manager/website_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatPic',
      debugShowCheckedModeBanner: false,
      theme: theme.purpleTheme,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('zh', 'CN'),
      ],
      home: WebsiteManager(),
    );
  }
}
