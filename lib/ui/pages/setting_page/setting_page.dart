import 'dart:io';

import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/setting/summary_tile.dart';
import 'package:catpic/ui/pages/download_page/android_download.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:smart_select/smart_select.dart';
import 'package:smart_select/src/model/chosen.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          I18n.of(context).setting,
          style: const TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
        if (Platform.isAndroid) ...buildAndroid(context),
      ],
    );
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
      SwitchListTile(
        title: Text(I18n.of(context).card_layout),
        secondary: const Icon(Icons.apps),
        value: settingStore.useCardWidget,
        onChanged: (value) {
          settingStore.setUseCardWidget(value);
        },
      ),
      SwitchListTile(
        title: Text(I18n.of(context).display_info_bar),
        secondary: const Icon(Icons.info_outline),
        value: settingStore.showCardDetail,
        onChanged: (value) {
          settingStore.setShowCardDetail(value);
        },
      ),
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.view_column_outlined),
          );
        },
        modalType: S2ModalType.popupDialog,
        selectedValue: settingStore.previewRowNum,
        onChange: (S2SingleSelected<int?> value) {
          settingStore.setPreviewRowNum(value.value!);
        },
        title: I18n.of(context).column_num,
        choiceItems: List.generate(
            5, (index) => S2Choice(title: '${index + 2}', value: index + 2)),
      ),
      SmartSelect<int>.single(
        tileBuilder: (context, S2SingleState<int?> state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.format_list_numbered_sharp),
          );
        },
        modalType: S2ModalType.popupDialog,
        selectedValue: settingStore.eachPageItem,
        onChange: (value) {
          settingStore.setEachPageItem(value.value!);
        },
        title: I18n.of(context).per_page_limit,
        choiceItems: List.generate(7, (index) {
          final len = (index + 2) * 10;
          return S2Choice(title: len.toString(), value: len);
        }),
      ),
    ];
  }
}
