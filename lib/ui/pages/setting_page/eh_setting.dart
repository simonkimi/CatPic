import 'package:catpic/data/models/ehentai/eh_website.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/api/misc_network.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/select_tile.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:catpic/data/models/gen/eh_storage.pbenum.dart';

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
        if (mainStore.websiteEntity is EhWebsiteEntity)
          ...buildReadSetting(context)
      ],
    );
  }

  List<Widget> buildReadSetting(BuildContext context) {
    final entity = mainStore.websiteEntity! as EhWebsiteEntity;
    return [
      SummaryTile(I18n.of(context).read),
      SelectTile<DisplayType>(
        title: I18n.of(context).display_model,
        leading: const Icon(Icons.chrome_reader_mode_outlined),
        items: [
          SelectTileItem(
            title: I18n.of(context).single_page,
            value: DisplayType.Single,
          ),
          SelectTileItem(
            title: I18n.of(context).double_page,
            value: DisplayType.DoubleNormal,
          ),
          SelectTileItem(
            title: I18n.of(context).double_page_without_cover,
            value: DisplayType.DoubleCover,
          ),
        ],
        selectedValue: entity.displayType,
        onChange: (value) {
          entity.displayType = value;
        },
      ),
      SelectTile<ReadAxis>(
        title: I18n.of(context).read_axis,
        leading: const Icon(Icons.directions_outlined),
        items: [
          SelectTileItem(
            title: I18n.of(context).left_to_right,
            value: ReadAxis.leftToRight,
          ),
          SelectTileItem(
            title: I18n.of(context).right_to_left,
            value: ReadAxis.rightToLeft,
          ),
          SelectTileItem(
            title: I18n.of(context).top_to_bottom,
            value: ReadAxis.topToButton,
          ),
        ],
        selectedValue: entity.readAxis,
        onChange: (value) {
          entity.readAxis = value;
        },
      ),
      SelectTile<ScreenAxis>(
        title: I18n.of(context).screen_axis,
        leading: const Icon(Icons.screen_rotation_outlined),
        items: [
          SelectTileItem(
              title: I18n.of(context).theme_follow_system,
              value: ScreenAxis.system),
          SelectTileItem(
              title: I18n.of(context).vertical, value: ScreenAxis.vertical),
          SelectTileItem(
              title: I18n.of(context).horizontal_left,
              value: ScreenAxis.horizontalLeft),
          SelectTileItem(
              title: I18n.of(context).horizontal_right,
              value: ScreenAxis.horizontalRight),
        ],
        selectedValue: entity.screenAxis,
        onChange: (value) {
          entity.screenAxis = value;
        },
      ),
    ];
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
        title: Text(I18n.of(context).database_info),
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
