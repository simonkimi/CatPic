import 'dart:io';

import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:catpic/ui/pages/booru_page/download_page/android_download.dart';
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
    final qualityChoice = [
      S2Choice(value: ImageQuality.preview, title: I18n.of(context).thumbnail),
      S2Choice(value: ImageQuality.sample, title: I18n.of(context).sample),
      S2Choice(value: ImageQuality.raw, title: I18n.of(context).raw),
    ];
    return ListView(
      cacheExtent: 9999,
      children: [
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
          title: I18n.of(context).thumbnail_quality,
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
              leading: const Icon(Icons.download_rounded),
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
        if (Platform.isAndroid) ...buildAndroid(context),
        const Divider(),
        const SummaryTile('杂项'),
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
