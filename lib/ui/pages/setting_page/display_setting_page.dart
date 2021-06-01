import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/seelct_tile.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/themes.dart';

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
      SelectTile<int>(
        leading: const Icon(Icons.color_lens_outlined),
        selectedValue: settingStore.theme,
        onChange: (value) {
          settingStore.setTheme(value);
        },
        title: I18n.of(context).color,
        items: [
          SelectTileItem(
              title: I18n.of(context).theme_blue, value: Themes.BLUE),
          SelectTileItem(
              title: I18n.of(context).theme_purple, value: Themes.PURPLE),
        ],
      ),
      SelectTile<int>(
        leading: const Icon(Icons.nightlight_round),
        selectedValue: settingStore.dartMode,
        onChange: (value) {
          settingStore.setDarkMode(value);
        },
        title: I18n.of(context).theme_dark_mode,
        items: [
          SelectTileItem(
              title: I18n.of(context).theme_follow_system,
              value: DarkMode.FOLLOW_SYSTEM),
          SelectTileItem(title: I18n.of(context).open, value: DarkMode.OPEN),
          SelectTileItem(title: I18n.of(context).close, value: DarkMode.CLOSE),
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
      SelectTile<int>(
        leading: const Icon(Icons.photo_size_select_small),
        selectedValue: settingStore.cardSize,
        onChange: (value) {
          settingStore.setCardSize(value);
        },
        title: I18n.of(context).card_size,
        items: [
          SelectTileItem(value: CardSize.SMALL, title: I18n.of(context).small),
          SelectTileItem(
              value: CardSize.MIDDLE, title: I18n.of(context).middle),
          SelectTileItem(value: CardSize.LARGE, title: I18n.of(context).large),
          SelectTileItem(value: CardSize.HUGE, title: I18n.of(context).huge),
        ],
      ),
      // 加载数量
      // 预加载
      SelectTile<int>(
        leading: const Icon(Icons.last_page_outlined),
        selectedValue: settingStore.preloadingNumber,
        onChange: (value) {
          settingStore.setPreloadingNumber(value);
        },
        title: I18n.of(context).preload,
        items: [0, 1, 3, 5, 7, 9, 11, 13, 15, 17]
            .map((e) => SelectTileItem(title: e.toString(), value: e))
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
