import 'dart:io';

import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/default_button.dart';
import 'package:catpic/ui/components/seelct_tile.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:path/path.dart' as p;

import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
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
    print('cache: ${settingStore.documentDir}');
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
      cacheExtent: 9999,
      children: [
        ...buildNetwork(context),
      ],
    );
  }

  List<Widget> buildNetwork(BuildContext context) {
    return [
      const Divider(),
      SummaryTile(I18n.of(context).network),
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
              Future<void> removeVideoCache(Directory dir) async {
                for (final child in dir.listSync()) {
                  if (child is File)
                    await child.delete();
                  else if (child is Directory) await removeVideoCache(child);
                }
              }

              await removeVideoCache(Directory(
                  p.join(settingStore.documentDir, 'cache', 'video')));
              BotToast.showText(text: I18n.of(context).clean_success);
              setState(() {});
            }
          },
        );
      }),
      ListTile(
        title: Text(I18n.of(context).host_manager),
        leading: const Icon(Icons.home_sharp),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HostManagerPage()));
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
