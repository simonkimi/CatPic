import 'dart:io';

import 'package:catpic/generated/l10n.dart';
import 'package:catpic/ui/components/setting/summary_tile.dart';
import 'package:catpic/ui/pages/download_page/android_download.dart';
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
          builder: (context) => buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        ...buildDisplaySetting(context),
        const Divider(),
        ...buildQuality(context),
      ],
    );
  }

  List<Widget> buildAndroid(BuildContext context) {
    return [
      SummaryTile(S.of(context).download),
      ListTile(
        title: Text(S.of(context).download_uri),
        subtitle: Text(settingStore.downloadUri.isNotEmpty
            ? settingStore.downloadUri
            : S.of(context).not_set),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => AndroidDownloadPage()));
        },
      )
    ];
  }

  List<Widget> buildQuality(BuildContext context) {
    final qualityChoice = [
      S2Choice(value: ImageQuality.preview, title: S.of(context).preview),
      S2Choice(value: ImageQuality.sample, title: S.of(context).sample),
      S2Choice(value: ImageQuality.raw, title: S.of(context).raw),
    ];
    return [
      SummaryTile(S.of(context).quality),
      SmartSelect<int>.single(
        tileBuilder: (context, state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.image_outlined),
          );
        },
        modalType: S2ModalType.popupDialog,
        value: settingStore.previewQuality,
        onChange: (value) {
          settingStore.setPreviewQuality(value.value);
        },
        title: S.of(context).preview_quality,
        choiceItems: qualityChoice,
      ),
      SmartSelect<int>.single(
        tileBuilder: (context, state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.image_search),
          );
        },
        modalType: S2ModalType.popupDialog,
        value: settingStore.displayQuality,
        onChange: (value) {
          settingStore.setDisplayQuality(value.value);
        },
        title: S.of(context).sample_quality,
        choiceItems: qualityChoice,
      ),
      SmartSelect<int>.single(
        tileBuilder: (context, state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.cloud_download_outlined),
          );
        },
        modalType: S2ModalType.popupDialog,
        value: settingStore.downloadQuality,
        onChange: (value) {
          settingStore.setDownloadQuality(value.value);
        },
        title: S.of(context).download_quality,
        choiceItems: qualityChoice,
      ),
    ];
  }

  List<Widget> buildDisplaySetting(BuildContext context) {
    return [
      SummaryTile(S.of(context).display),
      SwitchListTile(
        title: Text(S.of(context).card_layout),
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
            leading: const Icon(Icons.view_column_outlined),
          );
        },
        modalType: S2ModalType.popupDialog,
        value: settingStore.previewRowNum,
        onChange: (value) {
          settingStore.setPreviewRowNum(value.value);
        },
        title: S.of(context).column_num,
        choiceItems: List.generate(
            5, (index) => S2Choice(title: '${index + 2}', value: index + 2)),
      ),
      SwitchListTile(
        title: Text(S.of(context).display_info_bar),
        secondary: const Icon(Icons.info_outline),
        value: settingStore.showCardDetail,
        onChanged: (value) {
          settingStore.setShowCardDetail(value);
        },
      ),
      SmartSelect<int>.single(
        tileBuilder: (context, state) {
          return S2Tile.fromState(
            state,
            leading: const Icon(Icons.format_list_numbered_sharp),
          );
        },
        modalType: S2ModalType.popupDialog,
        value: settingStore.eachPageItem,
        onChange: (value) {
          settingStore.setEachPageItem(value.value);
        },
        title: S.of(context).per_page_limit,
        choiceItems: List.generate(7, (index) {
          final len = (index + 2) * 10;
          return S2Choice(title: len.toString(), value: len);
        }),
      ),
    ];
  }
}
