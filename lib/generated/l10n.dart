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

  /// `back`
  String get back {
    return Intl.message(
      'back',
      name: 'back',
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

  /// `Protocol`
  String get protocol {
    return Intl.message(
      'Protocol',
      name: 'protocol',
      desc: '',
      args: [],
    );
  }

  /// `Using more secure HTTPS protocol`
  String get protocol_https {
    return Intl.message(
      'Using more secure HTTPS protocol',
      name: 'protocol_https',
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

  /// `Trusted host`
  String get trusted_host {
    return Intl.message(
      'Trusted host',
      name: 'trusted_host',
      desc: '',
      args: [],
    );
  }

  /// `Get trusted host automatically`
  String get trusted_host_auto {
    return Intl.message(
      'Get trusted host automatically',
      name: 'trusted_host_auto',
      desc: '',
      args: [],
    );
  }

  /// `Workaround DNS poisoning in some nations`
  String get trusted_host_desc {
    return Intl.message(
      'Workaround DNS poisoning in some nations',
      name: 'trusted_host_desc',
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