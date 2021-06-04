import 'package:catpic/main.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:catpic/i18n.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class EHSettingPage extends StatelessWidget {
  const EHSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Observer(builder: (context) {
        return buildBody(context);
      }),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      cacheExtent: 9999,
      children: [
        ...buildDatabaseSetting(context),
      ],
    );
  }

  List<Widget> buildDatabaseSetting(BuildContext context) {
    return [
      SummaryTile(I18n.of(context).database),
      SwitchListTile(
        secondary: const Icon(Icons.tag),
        title: Text(I18n.of(context).eh_complete),
        value: settingStore.ehAutoCompute,
        onChanged: (value) async {
          if (value) {
            if (settingStore.ehDatabaseVersion.isEmpty) {
              if (await settingStore.updateEhDataBase()) {
                settingStore.setEhAutoCompute(true);
              }
            } else {
              settingStore.setEhAutoCompute(true);
            }
          } else {
            settingStore.setEhAutoCompute(false);
          }
        },
      ),
      SwitchListTile(
        secondary: const Icon(Icons.translate),
        title: Text(I18n.of(context).chinese_translate),
        value: settingStore.ehTranslate,
        onChanged: (value) async {
          if (value) {
            if (settingStore.ehDatabaseVersion.isEmpty) {
              if (await settingStore.updateEhDataBase()) {
                settingStore.setEhTranslate(true);
              }
            } else {
              settingStore.setEhTranslate(true);
            }
          } else {
            settingStore.setEhTranslate(false);
          }
        },
      ),
      ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(I18n.of(context).about),
        subtitle: Text(I18n.of(context).translate_about),
        onTap: () {
          _showAboutDialog(context);
        },
      ),
    ];
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('EhTagTranslation'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Text(I18n.of(context).project_url),
                    subtitle: const Text('https://github.com/EhTagTranslation'),
                    onTap: () {
                      launch('https://github.com/EhTagTranslation');
                    },
                  ),
                  ListTile(
                    title: Text(I18n.of(context).add_translate),
                    subtitle: const Text(
                        'https://github.com/EhTagTranslation/Editor/wiki'),
                    onTap: () {
                      launch('https://github.com/EhTagTranslation/Editor/wiki');
                    },
                  ),
                  ListTile(
                    title: Text(I18n.of(context).version),
                    subtitle: FutureBuilder<Tuple2<String, String>>(
                      future: getEhVersion(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data!.item1 ==
                              settingStore.ehDatabaseVersion) {
                            return Text(I18n.of(context).latest_version);
                          } else {
                            return Text(I18n.of(context).find_new_version);
                          }
                        }
                        return Text(I18n.of(context).check_update);
                      },
                    ),
                    onLongPress: () {
                      settingStore.updateEhDataBase();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
