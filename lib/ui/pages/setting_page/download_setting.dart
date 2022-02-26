import 'package:catpic/data/bridge/android_bridge.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/summary_tile.dart';
import 'package:catpic/ui/pages/booru_page/download_page/android_download.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class DownloadSettingPage extends StatelessWidget {
  const DownloadSettingPage({Key? key}) : super(key: key);

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
        ...buildAndroid(context),
      ],
    );
  }

  List<Widget> buildAndroid(BuildContext context) {
    return [
      SummaryTile(I18n.of(context).download),
      StatefulBuilder(builder: (context, setState) {
        return ListTile(
          title: Text(I18n.of(context).download_uri),
          subtitle: FutureBuilder<String?>(
            initialData: null,
            future: getSafUri(),
            builder: (context, snapshot) {
              return Text(snapshot.data ?? I18n.of(context).not_set);
            },
          ),
          onTap: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AndroidDownloadPage()))
                .whenComplete(() {
              setState(() => {});
            });
          },
          leading: const Icon(Icons.drive_file_move_outline),
        );
      }),
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
