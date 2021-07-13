import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:catpic/ui/pages/setting_page/booru_setting.dart';
import 'package:catpic/ui/pages/setting_page/display_setting_page.dart';
import 'package:catpic/ui/pages/setting_page/download_setting.dart';
import 'package:catpic/ui/pages/setting_page/eh_setting.dart';
import 'package:catpic/ui/pages/setting_page/network_setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../themes.dart';

class SettingPage extends StatelessWidget {
  static const route = 'SettingPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      cacheExtent: 9999,
      children: [
        SummaryTile(I18n.of(context).basic_settings),
        ListTile(
          leading: const Icon(Icons.laptop_chromebook_outlined),
          title: Text(I18n.of(context).display),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const DisplaySettingPage()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.cloud_outlined),
          title: Text(I18n.of(context).network),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const NetworkSettingPage()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.download_outlined),
          title: Text(I18n.of(context).download),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const DownloadSettingPage()));
          },
        ),
        SummaryTile(I18n.of(context).website_settings),
        ListTile(
          leading: SvgPicture.asset(
            'assets/svg/box.svg',
            color: isDarkMode(context) ? Colors.white : const Color(0xFF898989),
            height: 24,
            width: 24,
          ),
          title: const Text('Booru'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BooruSettingPage()));
          },
        ),
        ListTile(
          leading: SvgPicture.asset(
            'assets/svg/hentai.svg',
            color: isDarkMode(context) ? Colors.white : const Color(0xFF898989),
            height: 24,
            width: 24,
          ),
          title: const Text('EH'),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const EHSettingPage()));
          },
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        I18n.of(context).setting,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      leading: appBarBackButton(),
    );
  }
}
