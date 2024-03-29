import 'dart:io';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/gen/eh_preview.pb.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/fragment/main_drawer/main_drawer.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_extended_card/preview_extended_card.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/preview_page.dart';
import 'package:flutter/material.dart';

class EhHistoryPage extends StatelessWidget {
  const EhHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          I18n.of(context).history,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        leading: Platform.isAndroid
            ? Builder(
                builder: (context) => IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ))
            : appBarBackButton(),
      ),
      drawer: const MainDrawer(),
      body: StreamBuilder<List<EhGalleryHistoryTableData>>(
        stream: DB().galleryHistoryDao.all(),
        initialData: const [],
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.data!.map((e) {
              final item = PreViewItemModel.fromBuffer(e.pb);
              final adapter = mainStore.adapter! as EHAdapter;
              final heroTag = 'history${item.gid}${item.gtoken}';
              return PreviewExtendedCard(
                heroTag: heroTag,
                previewModel: item,
                adapter: adapter,
                onTap: () {
                  DB()
                      .galleryHistoryDao
                      .add(EhGalleryHistoryTableCompanion.insert(
                        gid: item.gid,
                        gtoken: item.gtoken,
                        pb: item.writeToBuffer(),
                      ));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return EhPreviewPage(
                          previewAspectRatio:
                              item.previewHeight / item.previewWidth,
                          previewModel: item,
                          heroTag: heroTag,
                          adapter: adapter,
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
