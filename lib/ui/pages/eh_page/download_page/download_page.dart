import 'dart:io';

import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:catpic/data/models/gen/eh_preview.pb.dart';
import 'package:catpic/data/store/eh_download/eh_download_store.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/fragment/main_drawer/main_drawer.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_extended_card/preview_extended_card.dart';
import 'package:catpic/ui/pages/eh_page/read_page/read_page.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../../themes.dart';
import 'store/loader_store.dart';

class EhDownloadPage extends StatelessWidget {
  const EhDownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          I18n.of(context).download,
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
                ),
              )
            : appBarBackButton(),
        actions: [
          IconButton(
              onPressed: () {
                DB().ehDownloadDao.deleteAll();
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      drawer: const MainDrawer(),
      body: StreamBuilder<List<EhDownloadTableData>>(
        stream: DB().ehDownloadDao.getAllStream(),
        initialData: const [],
        builder: (context, snapshot) {
          return Observer(
            builder: (context) {
              ehDownloadStore.downloadingList; // 消除警告
              return buildCardBody(snapshot, context);
            },
          );
        },
      ),
    );
  }

  ListView buildCardBody(
    AsyncSnapshot<List<EhDownloadTableData>> snapshot,
    BuildContext context,
  ) {
    return ListView(
      children: snapshot.data!.map((database) {
        final item = GalleryModel.fromBuffer(database.galleryPb);
        final adapter = EHAdapter(mainStore.websiteEntity!);
        final heroTag = 'download${item.gid}${item.token}';
        final model = PreViewItemModel(
          previewHeight: item.previewHeight,
          previewWidth: item.previewWidth,
          title: item.title,
          gid: item.gid,
          gtoken: item.token,
          tag: item.tag,
          uploadTime: item.uploadTime,
          uploader: item.uploader,
          pages: item.imageCount,
          language: item.language,
          stars: item.star,
          previewImg: item.previewImage,
          keyTags: adapter.translateKeyTag(item.tags
              .map((e) => e.value)
              .reduce((value, element) => value..addAll(element))
              .take(11)
              .map((e) => PreviewTag(
                    tag: '${e.parent.substring(0, 1)}:${e.value}',
                    translate: e.translate,
                  ))
              .toList()),
        );
        final task = ehDownloadStore.downloadingList.get(
          (e) =>
              e.gid == item.gid &&
              e.gtoken == item.token &&
              e.canceled.value == false,
        );

        return PreviewExtendedCard(
          heroTag: heroTag,
          previewModel: model,
          adapter: adapter,
          progress: task?.progress,
          onTap: () async {
            final loaderStore = DownloadLoaderStore(
              model: item,
              gid: item.gid,
              gtoken: item.token,
              adapter: adapter,
              imageCount: model.pages,
            );
            final readPage =
                await DB().ehReadHistoryDao.getPage(item.gid, item.token);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EhReadPage(
                store: loaderStore.readStore,
                startIndex: readPage,
              );
            }));
          },
          controllerWidget: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (task != null)
                  Obx(() => Text(
                      task.state.value == EhDownloadState.PARSE_PAGE
                          ? '解析中'
                          : '${task.finishPage.length}/${task.pageCount.value}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.subtitle2!.color,
                      )))
                else
                  Text(
                    database.status == EhDownloadState.FINISH ? '完成' : '未完成',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.subtitle2!.color,
                    ),
                  ),
                Row(
                  children: [
                    if (task != null)
                      StreamBuilder<int>(
                        stream: task.speed,
                        builder: (context, snapshot) {
                          final byteSpeed = snapshot.data ?? 0;
                          var speed = byteSpeed / 1024;
                          var b = 'KB/s';
                          if (speed > 1024) {
                            speed /= 1024;
                            b = 'MB/s';
                          }
                          return Text('${speed.toStringAsFixed(2)} $b',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .color,
                              ));
                        },
                      ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () {
                        if (task == null) {
                          ehDownloadStore.startDownload(
                            database,
                            adapter.website,
                          );
                        } else {
                          ehDownloadStore.cancelTask(task);
                        }
                      },
                      child: task == null
                          ? const Icon(Icons.play_arrow)
                          : const Icon(Icons.pause),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0)),
                        minimumSize:
                            MaterialStateProperty.all(const Size(0, 0)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: MaterialStateProperty.all(
                          isDarkMode(context)
                              ? const Color(0xFFFDFDFD)
                              : Colors.black,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildStar(BuildContext context, int tag, double star) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RatingBar.builder(
                  itemSize: 16,
                  ignoreGestures: true,
                  initialRating: star,
                  onRatingUpdate: (value) {},
                  itemBuilder: (BuildContext context, int index) {
                    return const Icon(
                      Icons.star,
                      color: Colors.amber,
                    );
                  },
                ),
                const SizedBox(width: 5),
                Text(
                  star.toString(),
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.subtitle2!.color),
                )
              ],
            ),
            const SizedBox(height: 3),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 50),
              child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: tag.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      tag.translate(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
