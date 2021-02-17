import 'package:catpic/generated/l10n.dart';
import 'package:catpic/ui/components/setting/summary_tile.dart';
import 'package:catpic/ui/store/setting/setting_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:smart_select/smart_select.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).setting),
      ),
      body: SafeArea(
        child: Observer(
          builder: (context) => buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return ListView(
      children: [
        ...buildDisplaySetting(),
      ],
    );
  }

  List<Widget> buildDisplaySetting() {
    return [
      const SummaryTile('显示'),
      SwitchListTile(
        title: Text('卡片布局'),
        secondary: const Icon(Icons.apps),
        value: settingStore.useCardWidget,
        onChanged: (value) {
          settingStore.setUseCardWidget(value);
        },
      ),
      SmartSelect<int>.single(
        tileBuilder: (context, state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.view_column),
          );
        },
        modalType: S2ModalType.popupDialog,
        value: settingStore.previewRowNum,
        onChange: (value) {
          settingStore.setPreviewRowNum(value.value);
        },
        title: '列数',
        choiceItems: [
          S2Choice(value: 2, title: '2'),
          S2Choice(value: 3, title: '3'),
          S2Choice(value: 4, title: '4'),
          S2Choice(value: 5, title: '5'),
        ],
      )
    ];
  }
}
