// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Not set yet`
  String get not_set {
    return Intl.message(
      'Not set yet',
      name: 'not_set',
      desc: '',
      args: [],
    );
  }

  /// `Website Manager`
  String get website_manager {
    return Intl.message(
      'Website Manager',
      name: 'website_manager',
      desc: '',
      args: [],
    );
  }

  /// `Add Website`
  String get add_website {
    return Intl.message(
      'Add Website',
      name: 'add_website',
      desc: '',
      args: [],
    );
  }

  /// `BASIC SETTINGS`
  String get basic_settings {
    return Intl.message(
      'BASIC SETTINGS',
      name: 'basic_settings',
      desc: '',
      args: [],
    );
  }

  /// `Nickname`
  String get website_nickname {
    return Intl.message(
      'Nickname',
      name: 'website_nickname',
      desc: '',
      args: [],
    );
  }

  /// `WEBSITE SETTINGS`
  String get website_settings {
    return Intl.message(
      'WEBSITE SETTINGS',
      name: 'website_settings',
      desc: '',
      args: [],
    );
  }

  /// `Host`
  String get host {
    return Intl.message(
      'Host',
      name: 'host',
      desc: '',
      args: [],
    );
  }

  /// `Scheme`
  String get scheme {
    return Intl.message(
      'Scheme',
      name: 'scheme',
      desc: '',
      args: [],
    );
  }

  /// `Using more secure HTTPS scheme`
  String get scheme_https {
    return Intl.message(
      'Using more secure HTTPS scheme',
      name: 'scheme_https',
      desc: '',
      args: [],
    );
  }

  /// `Site type`
  String get site_type {
    return Intl.message(
      'Site type',
      name: 'site_type',
      desc: '',
      args: [],
    );
  }

  /// `ADVANCED SETTINGS (optional)`
  String get advanced_settings {
    return Intl.message(
      'ADVANCED SETTINGS (optional)',
      name: 'advanced_settings',
      desc: '',
      args: [],
    );
  }

  /// `Use custom host list`
  String get use_host_list {
    return Intl.message(
      'Use custom host list',
      name: 'use_host_list',
      desc: '',
      args: [],
    );
  }

  /// `Get trusted host failed`
  String get trusted_host_auto_failed {
    return Intl.message(
      'Get trusted host failed',
      name: 'trusted_host_auto_failed',
      desc: '',
      args: [],
    );
  }

  /// `Workaround DNS poisoning in some nations`
  String get use_host_list_desc {
    return Intl.message(
      'Workaround DNS poisoning in some nations',
      name: 'use_host_list_desc',
      desc: '',
      args: [],
    );
  }

  /// `Domain Fronting`
  String get domain_fronting {
    return Intl.message(
      'Domain Fronting',
      name: 'domain_fronting',
      desc: '',
      args: [],
    );
  }

  /// `Bypass SNI blocking`
  String get domain_fronting_desc {
    return Intl.message(
      'Bypass SNI blocking',
      name: 'domain_fronting_desc',
      desc: '',
      args: [],
    );
  }

  /// `DISPLAY SETTINGS`
  String get display_setting {
    return Intl.message(
      'DISPLAY SETTINGS',
      name: 'display_setting',
      desc: '',
      args: [],
    );
  }

  /// `Use extended layout`
  String get use_extend_layout {
    return Intl.message(
      'Use extended layout',
      name: 'use_extend_layout',
      desc: '',
      args: [],
    );
  }

  /// `Tags, ratings, uploader, etc.`
  String get extend_layout {
    return Intl.message(
      'Tags, ratings, uploader, etc.',
      name: 'extend_layout',
      desc: '',
      args: [],
    );
  }

  /// `Cover image and resolution only`
  String get compact_layout {
    return Intl.message(
      'Cover image and resolution only',
      name: 'compact_layout',
      desc: '',
      args: [],
    );
  }

  /// `The details page shows a large picture`
  String get display_original {
    return Intl.message(
      'The details page shows a large picture',
      name: 'display_original',
      desc: '',
      args: [],
    );
  }

  /// `There is no website, go and add one!`
  String get no_website {
    return Intl.message(
      'There is no website, go and add one!',
      name: 'no_website',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Host Manager`
  String get host_manager {
    return Intl.message(
      'Host Manager',
      name: 'host_manager',
      desc: '',
      args: [],
    );
  }

  /// `Host cannot be empty`
  String get host_empty {
    return Intl.message(
      'Host cannot be empty',
      name: 'host_empty',
      desc: '',
      args: [],
    );
  }

  /// `Host and IP cannot be empty`
  String get host_or_ip_empty {
    return Intl.message(
      'Host and IP cannot be empty',
      name: 'host_or_ip_empty',
      desc: '',
      args: [],
    );
  }

  /// `Illegal IP`
  String get illegal_ip {
    return Intl.message(
      'Illegal IP',
      name: 'illegal_ip',
      desc: '',
      args: [],
    );
  }

  /// `Custom host must be turned on first`
  String get turn_on_host {
    return Intl.message(
      'Custom host must be turned on first',
      name: 'turn_on_host',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}