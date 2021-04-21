import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'main.dart';

class I18n {
  static List<Locale> supportedLocales = AppLocalizations.supportedLocales;

  static AppLocalizations get g =>
      Localizations.of(AppNavigator().context, AppLocalizations)!;

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  static BuildContext get context => AppNavigator().context;
}
