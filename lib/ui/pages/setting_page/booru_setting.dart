import 'dart:io';

import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/seelct_tile.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:catpic/ui/pages/booru_page/download_page/android_download.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../i18n.dart';
import '../../../main.dart';

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
      SelectTileItem(
          value: ImageQuality.preview, title: I18n.of(context).thumbnail),
      SelectTileItem(
          value: ImageQuality.sample, title: I18n.of(context).sample),
      SelectTileItem(value: ImageQuality.raw, title: I18n.of(context).raw),
    ];

    return ListView(
      cacheExtent: 9999,
      children: [
        SummaryTile(I18n.of(context).quality),
        SelectTile<int>(
          leading: const Icon(Icons.preview),
          title: I18n.of(context).thumbnail_quality,
          items: [
            SelectTileItem(
                value: ImageQuality.preview, title: I18n.of(context).thumbnail),
            SelectTileItem(
                value: ImageQuality.sample, title: I18n.of(context).sample),
            SelectTileItem(
                value: ImageQuality.raw, title: I18n.of(context).raw),
          ],
          selectedValue: settingStore.previewQuality,
          onChange: (value) {
            settingStore.setPreviewQuality(value);
          },
        ),
        SelectTile<int>(
          leading: const Icon(Icons.image_search),
          selectedValue: settingStore.displayQuality,
          onChange: (value) {
            settingStore.setDisplayQuality(value);
          },
          title: I18n.of(context).sample_quality,
          items: qualityChoice,
        ),
        SelectTile<int>(
          leading: const Icon(Icons.download_rounded),
          selectedValue: settingStore.downloadQuality,
          onChange: (value) {
            settingStore.setDownloadQuality(value);
          },
          title: I18n.of(context).download_quality,
          items: qualityChoice,
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
        SelectTile<int>(
          leading: const Icon(Icons.format_list_numbered_sharp),
          selectedValue: settingStore.eachPageItem,
          onChange: (value) {
            settingStore.setEachPageItem(value);
          },
          title: I18n.of(context).per_page_limit,
          items: [20, 50, 100, 200]
              .map((e) => SelectTileItem(title: e.toString(), value: e))
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
