import 'dart:io';

import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:catpic/ui/pages/download_page/android_download.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/ui/pages/host_manager_page/host_manager_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:smart_select/smart_select.dart';
import 'package:smart_select/src/model/chosen.dart';
import 'package:catpic/main.dart';

import '../../../themes.dart';

class SettingPage extends StatelessWidget {
  static const route = 'SettingPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Observer(
          builder: (context) => buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        ...buildDisplaySetting(context),
        ...buildQuality(context),
        ...buildNetwork(context),
        if (Platform.isAndroid) ...buildAndroid(context),
      ],
    );
  }

  List<Widget> buildNetwork(BuildContext context) {
    return [
      const Divider(),
      SummaryTile(I18n.of(context).network),
      ListTile(
        title: Text(I18n.of(context).host_manager),
        leading: const Icon(Icons.home_sharp),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HostManagerPage()));
        },
      )
    ];
  }

  List<Widget> buildAndroid(BuildContext context) {
    return [
      const Divider(),
      SummaryTile(I18n.of(context).download),
      ListTile(
        title: Text(I18n.of(context).download_uri),
        subtitle: Text(settingStore.downloadUri.isNotEmpty
            ? settingStore.downloadUri
            : I18n.of(context).not_set),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => AndroidDownloadPage()));
        },
        leading: const Icon(Icons.drive_file_move_outline),
      )
    ];
  }

  List<Widget> buildQuality(BuildContext context) {
    final qualityChoice = [
      S2Choice(value: ImageQuality.preview, title: I18n.of(context).preview),
      S2Choice(value: ImageQuality.sample, title: I18n.of(context).sample),
      S2Choice(value: ImageQuality.raw, title: I18n.of(context).raw),
    ];
    return [
      const Divider(),
      SummaryTile(I18n.of(context).quality),
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.preview),
          );
        },
        modalType: S2ModalType.popupDialog,
        modalConfig: const S2ModalConfig(barrierColor: Colors.black54),
        selectedValue: settingStore.previewQuality,
        onChange: (S2SingleSelected<int?> value) {
          settingStore.setPreviewQuality(value.value!);
        },
        title: I18n.of(context).preview_quality,
        choiceItems: qualityChoice,
      ),
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.image_search),
          );
        },
        modalType: S2ModalType.popupDialog,
        modalConfig: const S2ModalConfig(barrierColor: Colors.black54),
        selectedValue: settingStore.displayQuality,
        onChange: (S2SingleSelected<int?> value) {
          settingStore.setDisplayQuality(value.value!);
        },
        title: I18n.of(context).sample_quality,
        choiceItems: qualityChoice,
      ),
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.cloud_download_outlined),
          );
        },
        modalType: S2ModalType.popupDialog,
        modalConfig: const S2ModalConfig(barrierColor: Colors.black54),
        selectedValue: settingStore.downloadQuality,
        onChange: (S2SingleSelected<int?> value) {
          settingStore.setDownloadQuality(value.value!);
        },
        title: I18n.of(context).download_quality,
        choiceItems: qualityChoice,
      ),
    ];
  }

  List<Widget> buildDisplaySetting(BuildContext context) {
    return [
      SummaryTile(I18n.of(context).display),
      // 卡片布局
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.color_lens),
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
        title: I18n.of(context).theme,
        choiceItems: [
          S2Choice(title: I18n.of(context).theme_blue, value: Themes.BLUE),
          S2Choice(title: I18n.of(context).theme_purple, value: Themes.PURPLE),
          S2Choice(
              title: I18n.of(context).theme_dark_blue, value: Themes.DARK_BLUE),
        ],
      ),
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
            leading: const Icon(Icons.view_column_outlined),
          );
        },
        modalType: S2ModalType.popupDialog,
        modalConfig: const S2ModalConfig(barrierColor: Colors.black54),
        selectedValue: settingStore.previewRowNum,
        onChange: (S2SingleSelected<int?> value) {
          settingStore.setPreviewRowNum(value.value!);
        },
        title: I18n.of(context).column_num,
        choiceItems: List.generate(
            5, (index) => S2Choice(title: '${index + 2}', value: index + 2)),
      ),
      // 加载数量
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.format_list_numbered_sharp),
          );
        },
        modalType: S2ModalType.popupDialog,
        modalConfig: const S2ModalConfig(barrierColor: Colors.black54),
        selectedValue: settingStore.eachPageItem,
        onChange: (S2SingleSelected<int?> value) {
          settingStore.setEachPageItem(value.value!);
        },
        title: I18n.of(context).per_page_limit,
        choiceItems: [20, 50, 100, 200]
            .map((e) => S2Choice(title: e.toString(), value: e))
            .toList(),
      ),
      // 预加载
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.autorenew_sharp),
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
        secondary: const Icon(Icons.block),
        value: settingStore.saveModel,
        onChanged: (value) {
          settingStore.setSaveModel(value);
        },
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
