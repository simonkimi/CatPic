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

class DisplaySettingPage extends StatelessWidget {
  const DisplaySettingPage({Key? key}) : super(key: key);

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
        ...buildThemeSetting(context),
        ...buildDisplaySetting(context),
      ],
    );
  }

  List<Widget> buildThemeSetting(BuildContext context) {
    return [
      SummaryTile(I18n.of(context).theme),
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.color_lens_outlined),
          );
        },
        modalType: S2ModalType.popupDialog,
        modalConfig: const S2ModalConfig(barrierColor: Colors.black54),
        selectedValue: settingStore.theme,
        onChange: (S2SingleSelected<int?> value) {
          Future.delayed(const Duration(milliseconds: 200), () {
            settingStore.setTheme(value.value!);
          });
        },
        title: I18n.of(context).color,
        choiceItems: [
          S2Choice(title: I18n.of(context).theme_blue, value: Themes.BLUE),
          S2Choice(title: I18n.of(context).theme_purple, value: Themes.PURPLE),
        ],
      ),
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.nightlight_round),
          );
        },
        modalType: S2ModalType.popupDialog,
        modalConfig: const S2ModalConfig(barrierColor: Colors.black54),
        selectedValue: settingStore.dartMode,
        onChange: (S2SingleSelected<int?> value) {
          Future.delayed(const Duration(milliseconds: 200), () {
            settingStore.setDarkMode(value.value!);
          });
        },
        title: I18n.of(context).theme_dark_mode,
        choiceItems: [
          S2Choice(
              title: I18n.of(context).theme_follow_system,
              value: DarkMode.FOLLOW_SYSTEM),
          S2Choice(title: I18n.of(context).open, value: DarkMode.OPEN),
          S2Choice(title: I18n.of(context).close, value: DarkMode.CLOSE),
        ],
      ),
      SwitchListTile(
        title: Text(I18n.of(context).dark_mask),
        secondary: const Icon(Icons.lightbulb_outline),
        value: settingStore.darkMask,
        onChanged: (value) {
          settingStore.setDarkMask(value);
        },
      ),
    ];
  }

  List<Widget> buildDisplaySetting(BuildContext context) {
    return [
      SummaryTile(I18n.of(context).display),
      // 卡片布局
      SwitchListTile(
        title: Text(I18n.of(context).card_layout),
        secondary: const Icon(Icons.apps),
        value: settingStore.useCardWidget,
        onChanged: (value) {
          settingStore.setUseCardWidget(value);
        },
      ),
      // 显示信息栏
      SwitchListTile(
        title: Text(I18n.of(context).display_info_bar),
        secondary: const Icon(Icons.info_outline),
        value: settingStore.showCardDetail,
        onChanged: (value) {
          settingStore.setShowCardDetail(value);
        },
      ),
      // 列数
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.photo_size_select_small),
          );
        },
        modalType: S2ModalType.popupDialog,
        modalConfig: const S2ModalConfig(barrierColor: Colors.black54),
        selectedValue: settingStore.cardSize,
        onChange: (S2SingleSelected<int?> value) {
          settingStore.setCardSize(value.value!);
        },
        title: I18n.of(context).card_size,
        choiceItems: [
          S2Choice(value: CardSize.SMALL, title: I18n.of(context).small),
          S2Choice(value: CardSize.MIDDLE, title: I18n.of(context).middle),
          S2Choice(value: CardSize.LARGE, title: I18n.of(context).large),
          S2Choice(value: CardSize.HUGE, title: I18n.of(context).huge),
        ],
      ),
      // 加载数量
      // 预加载
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.last_page_outlined),
          );
        },
        modalType: S2ModalType.popupDialog,
        modalConfig: const S2ModalConfig(barrierColor: Colors.black54),
        selectedValue: settingStore.preloadingNumber,
        onChange: (S2SingleSelected<int?> value) {
          settingStore.setPreloadingNumber(value.value!);
        },
        title: I18n.of(context).preload,
        choiceItems: [0, 1, 3, 5, 7, 9, 11, 13, 15, 17]
            .map((e) => S2Choice(title: e.toString(), value: e))
            .toList(),
      ),
    ];
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
