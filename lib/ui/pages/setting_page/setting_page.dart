import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/pages/setting_page/booru_setting.dart';
import 'package:catpic/ui/pages/setting_page/display_setting_page.dart';
import 'package:catpic/ui/pages/setting_page/eh_setting.dart';
import 'package:catpic/ui/pages/setting_page/network_setting_page.dart';
import 'package:flutter/material.dart';

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
        ListTile(
          leading: const Icon(Icons.markunread_mailbox_outlined),
          title: const Text('Booru'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BooruSettingPage()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.book),
          title: const Text('EH'),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const EHSettingPage()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_display),
          title: Text(I18n.of(context).display),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const DisplaySettingPage()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.network_cell),
          title: Text(I18n.of(context).network),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const NetworkSettingPage()));
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
