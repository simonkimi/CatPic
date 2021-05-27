import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:smart_select/smart_select.dart';
import 'package:smart_select/src/model/chosen.dart';

import '../../../i18n.dart';
import '../../../main.dart';
import '../../../themes.dart';

class BooruSettingPage extends StatelessWidget {
  const BooruSettingPage({Key? key}) : super(key: key);

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
        SwitchListTile(
          title: Text(I18n.of(context).auto_complete),
          subtitle: Text(settingStore.autoCompleteUseNetwork
              ? I18n.of(context).auto_complete_online
              : I18n.of(context).auto_complete_local),
          secondary: const Icon(Icons.tag),
          value: settingStore.autoCompleteUseNetwork,
          onChanged: (value) {
            settingStore.setAutoCompleteUseNetwork(value);
          },
        ),
        SwitchListTile(
          title: Text(I18n.of(context).safe_model),
          secondary: const Icon(Icons.child_care),
          value: settingStore.saveModel,
          onChanged: (value) {
            settingStore.setSaveModel(value);
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
