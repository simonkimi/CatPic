import 'dart:io';

import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/default_button.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:catpic/ui/pages/booru_page/download_page/android_download.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:smart_select/smart_select.dart';
import 'package:smart_select/src/model/chosen.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:path/path.dart' as p;

import '../../../i18n.dart';
import '../../../main.dart';
import 'host_manager_page.dart';

class NetworkSettingPage extends StatelessWidget {
  const NetworkSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Observer(builder: (context) {
        return buildBody(context);
      }),
    );
  }

  Future<int> getCacheSize() async {
    Future<int> getDirSize(Directory dir) async {
      var currentSize = 0;
      for (final child in dir.listSync()) {
        if (child is File)
          currentSize += await child.length();
        else if (child is Directory) currentSize += await getDirSize(child);
      }
      return currentSize;
    }

    return getDirSize(Directory(p.join(settingStore.documentDir, 'cache')));
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        ...buildNetwork(context),
        ...buildQuality(context),
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
      ),
      StatefulBuilder(builder: (context, setState) {
        return ListTile(
          title: Text(I18n.of(context).cache),
          leading: const Icon(Icons.cached),
          trailing: FutureBuilder<int>(
            future: getCacheSize(),
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                    ((snapshot.data ?? 0) / (1024 * 1024)).toStringAsFixed(2) +
                        ' MB'),
              );
            },
          ),
          onTap: () async {
            final result = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(I18n.of(context).clean_cache),
                    content: Text(I18n.of(context).confirm_clean_cache),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(I18n.of(context).negative),
                      ),
                      DefaultButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(I18n.of(context).positive),
                      )
                    ],
                  );
                });
            if (result == true) {
              await settingStore.dioCacheOptions.store!.clean();
              BotToast.showText(text: I18n.of(context).clean_success);
              setState(() {});
            }
          },
        );
      }),
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
