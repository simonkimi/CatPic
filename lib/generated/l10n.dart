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

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get posts {
    return Intl.message(
      'Posts',
      name: 'posts',
      desc: '',
      args: [],
    );
  }

  /// `Pools`
  String get pools {
    return Intl.message(
      'Pools',
      name: 'pools',
      desc: '',
      args: [],
    );
  }

  /// `Downloads`
  String get download {
    return Intl.message(
      'Downloads',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting {
    return Intl.message(
      'Settings',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Hot`
  String get hot {
    return Intl.message(
      'Hot',
      name: 'hot',
      desc: '',
      args: [],
    );
  }

  /// `Favourite`
  String get favourite {
    return Intl.message(
      'Favourite',
      name: 'favourite',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
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

  /// `Basic Settings`
  String get basic_settings {
    return Intl.message(
      'Basic Settings',
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

  /// `Website Settings`
  String get website_settings {
    return Intl.message(
      'Website Settings',
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

  /// `Advanced Settings`
  String get advanced_settings {
    return Intl.message(
      'Advanced Settings',
      name: 'advanced_settings',
      desc: '',
      args: [],
    );
  }

  /// `Use DoH`
  String get use_doh {
    return Intl.message(
      'Use DoH',
      name: 'use_doh',
      desc: '',
      args: [],
    );
  }

  /// `Workaround DNS poisoning in some nations`
  String get use_doh_desc {
    return Intl.message(
      'Workaround DNS poisoning in some nations',
      name: 'use_doh_desc',
      desc: '',
      args: [],
    );
  }

  /// `Direct Link`
  String get direct_link {
    return Intl.message(
      'Direct Link',
      name: 'direct_link',
      desc: '',
      args: [],
    );
  }

  /// `Bypass SNI blocking`
  String get direct_link_desc {
    return Intl.message(
      'Bypass SNI blocking',
      name: 'direct_link_desc',
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

  /// `There is no website, click me to add one!`
  String get to_add_website {
    return Intl.message(
      'There is no website, click me to add one!',
      name: 'to_add_website',
      desc: '',
      args: [],
    );
  }

  /// `safe`
  String get safe {
    return Intl.message(
      'safe',
      name: 'safe',
      desc: '',
      args: [],
    );
  }

  /// `explicit`
  String get explicit {
    return Intl.message(
      'explicit',
      name: 'explicit',
      desc: '',
      args: [],
    );
  }

  /// `questionable`
  String get questionable {
    return Intl.message(
      'questionable',
      name: 'questionable',
      desc: '',
      args: [],
    );
  }

  /// `Resolution`
  String get resolution {
    return Intl.message(
      'Resolution',
      name: 'resolution',
      desc: '',
      args: [],
    );
  }

  /// `ID`
  String get post_id {
    return Intl.message(
      'ID',
      name: 'post_id',
      desc: '',
      args: [],
    );
  }

  /// `Score`
  String get score {
    return Intl.message(
      'Score',
      name: 'score',
      desc: '',
      args: [],
    );
  }

  /// `Source`
  String get source {
    return Intl.message(
      'Source',
      name: 'source',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get rating {
    return Intl.message(
      'Rating',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `Connecting...`
  String get connecting {
    return Intl.message(
      'Connecting...',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Tap to reload`
  String get tap_to_reload {
    return Intl.message(
      'Tap to reload',
      name: 'tap_to_reload',
      desc: '',
      args: [],
    );
  }

  /// `Pull up Load more`
  String get idle_loading {
    return Intl.message(
      'Pull up Load more',
      name: 'idle_loading',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed`
  String get load_fail {
    return Intl.message(
      'Load Failed',
      name: 'load_fail',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading_text {
    return Intl.message(
      'Loading...',
      name: 'loading_text',
      desc: '',
      args: [],
    );
  }

  /// `No more data`
  String get no_more_text {
    return Intl.message(
      'No more data',
      name: 'no_more_text',
      desc: '',
      args: [],
    );
  }

  /// `Release to load more`
  String get can_load_text {
    return Intl.message(
      'Release to load more',
      name: 'can_load_text',
      desc: '',
      args: [],
    );
  }

  /// `Network Error`
  String get network_error {
    return Intl.message(
      'Network Error',
      name: 'network_error',
      desc: '',
      args: [],
    );
  }

  /// `Display`
  String get display {
    return Intl.message(
      'Display',
      name: 'display',
      desc: '',
      args: [],
    );
  }

  /// `Thumbnail`
  String get preview {
    return Intl.message(
      'Thumbnail',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `Larger`
  String get sample {
    return Intl.message(
      'Larger',
      name: 'sample',
      desc: '',
      args: [],
    );
  }

  /// `Raw`
  String get raw {
    return Intl.message(
      'Raw',
      name: 'raw',
      desc: '',
      args: [],
    );
  }

  /// `Preview Quality`
  String get preview_quality {
    return Intl.message(
      'Preview Quality',
      name: 'preview_quality',
      desc: '',
      args: [],
    );
  }

  /// `Sample Quality`
  String get sample_quality {
    return Intl.message(
      'Sample Quality',
      name: 'sample_quality',
      desc: '',
      args: [],
    );
  }

  /// `Download Quality`
  String get download_quality {
    return Intl.message(
      'Download Quality',
      name: 'download_quality',
      desc: '',
      args: [],
    );
  }

  /// `Quality`
  String get quality {
    return Intl.message(
      'Quality',
      name: 'quality',
      desc: '',
      args: [],
    );
  }

  /// `Card Layout`
  String get card_layout {
    return Intl.message(
      'Card Layout',
      name: 'card_layout',
      desc: '',
      args: [],
    );
  }

  /// `Column Num`
  String get column_num {
    return Intl.message(
      'Column Num',
      name: 'column_num',
      desc: '',
      args: [],
    );
  }

  /// `Per Page Limit`
  String get per_page_limit {
    return Intl.message(
      'Per Page Limit',
      name: 'per_page_limit',
      desc: '',
      args: [],
    );
  }

  /// `Display Info Bar`
  String get display_info_bar {
    return Intl.message(
      'Display Info Bar',
      name: 'display_info_bar',
      desc: '',
      args: [],
    );
  }

  /// `Download Location`
  String get download_uri {
    return Intl.message(
      'Download Location',
      name: 'download_uri',
      desc: '',
      args: [],
    );
  }

  /// `To save pictures in saf mode, you must select a directory to authorize catpic to access`
  String get saf_desc1 {
    return Intl.message(
      'To save pictures in saf mode, you must select a directory to authorize catpic to access',
      name: 'saf_desc1',
      desc: '',
      args: [],
    );
  }

  /// `Step 1: click the top right corner to display the internal storage device (some devices are not required)`
  String get saf_desc2 {
    return Intl.message(
      'Step 1: click the top right corner to display the internal storage device (some devices are not required)',
      name: 'saf_desc2',
      desc: '',
      args: [],
    );
  }

  /// `Step 2: select devices in the sidebar (some devices are not required)`
  String get saf_desc3 {
    return Intl.message(
      'Step 2: select devices in the sidebar (some devices are not required)',
      name: 'saf_desc3',
      desc: '',
      args: [],
    );
  }

  /// `Step 3: choose a path you like, or create a new folder`
  String get saf_desc4 {
    return Intl.message(
      'Step 3: choose a path you like, or create a new folder',
      name: 'saf_desc4',
      desc: '',
      args: [],
    );
  }

  /// `Step 4: click confirm to authorize access to this folder`
  String get saf_desc5 {
    return Intl.message(
      'Step 4: click confirm to authorize access to this folder',
      name: 'saf_desc5',
      desc: '',
      args: [],
    );
  }

  /// `Download Manager`
  String get download_manager {
    return Intl.message(
      'Download Manager',
      name: 'download_manager',
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