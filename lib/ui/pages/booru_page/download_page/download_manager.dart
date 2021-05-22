import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/download.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/data/store/download/download_store.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:catpic/ui/pages/booru_page/post_image_view/post_image_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:catpic/utils/utils.dart';
import 'package:catpic/main.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';

class DownloadManagerPage extends StatelessWidget {
  static const route = 'DownloadManagerPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: buildFuture(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: () {
          downloadStore.startDownload().then((value) {
            BotToast.showText(text: I18n.of(context).download_start);
          });
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        I18n.of(context).download_manager,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      centerTitle: true,
      leading: appBarBackButton(),
    );
  }

  Widget buildFuture(BuildContext context) {
    // 能优化, 先放着, 能用就行
    return FutureBuilder<List<WebsiteTableData>>(
      // 方便由id获取WebsiteEntity, 以构造Dio
      future: DB().websiteDao.getAll(),
      initialData: const [],
      builder: (_, websiteList) {
        return StreamBuilder<List<DownloadTableData>>(
            // 获取下载历史数据库
            stream: DB().downloadDao.getAllStream(),
            initialData: const [],
            builder: (_, downloadList) {
              return buildBody(
                context: context,
                websiteList: websiteList.data!,
                downloadList: downloadList.data!,
              );
            });
      },
    );
  }

  Widget buildBody({
    required BuildContext context,
    required List<DownloadTableData> downloadList,
    required List<WebsiteTableData> websiteList,
  }) {
    return ListView(
      children: [
        buildDownloadingList(context, downloadList, websiteList),
        buildDownloadedList(context, downloadList, websiteList),
      ],
    );
  }

  Widget buildDownloadingList(
    BuildContext context,
    List<DownloadTableData> downloadList,
    List<WebsiteTableData> websiteList,
  ) {
    return Observer(builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: downloadStore.downloadingList.map((element) {
          return _buildDownloadCard(
            context: context,
            task: element,
            dio: DioBuilder.build(
                websiteList.get((e) => e.id == element.database.id)),
            downloadTable: element.database,
          );
        }).toList(),
      );
    });
  }

  Widget buildDownloadedList(
    BuildContext context,
    List<DownloadTableData> downloadList,
    List<WebsiteTableData> websiteList,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: downloadList
          .where((e) =>
              e.status == DownloadStatus.FINISH ||
              e.status == DownloadStatus.FAIL)
          .toList()
          .reversed
          .map((e) {
        return _buildDownloadCard(
          dio: DioBuilder.build(
              websiteList.get((website) => e.websiteId == website.id)),
          context: context,
          downloadTable: e,
          task: null,
        );
      }).toList(),
    );
  }

  Widget _buildDownloadCard({
    required BuildContext context,
    required Dio dio,
    required DownloadTableData downloadTable,
    required DownLoadTask? task,
  }) {
    return Container(
      height: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostImageViewPage.count(
                dio: dio,
                index: 0,
                postList: [
                  BooruPost.fromJson(jsonDecode(downloadTable.booruJson))
                ],
              ),
            ),
          );
        },
        onLongPress: () async {
          vibrate(duration: 50, amplitude: 100);
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(I18n.of(context).display),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PostImageViewPage.count(
                                  dio: dio,
                                  index: 0,
                                  postList: [
                                    BooruPost.fromJson(
                                        jsonDecode(downloadTable.booruJson))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text(I18n.of(context).delete),
                          onTap: () {
                            Navigator.of(context).pop();
                            downloadStore.deleteDownload(downloadTable);
                          },
                        ),
                        ListTile(
                          title: Text(I18n.of(context).download_restart),
                          onTap: () {
                            Navigator.of(context).pop();
                            downloadStore.restartDownload(downloadTable);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: Card(
          key: ValueKey('DownloadCard${downloadTable.id}'),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  width: 60,
                  child: buildCardImage(dio, downloadTable.previewUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '# ${downloadTable.postId}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        downloadTable.imgUrl.replaceAll('', '\u200B'),
                        style: Theme.of(context).textTheme.subtitle2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(downloadTable.createTime.toString(),
                          style: Theme.of(context).textTheme.subtitle2),
                      const SizedBox(height: 5),
                      if (downloadTable.status == DownloadStatus.FAIL)
                        LinearProgressIndicator(
                          value: task?.progress.value ?? 1,
                          valueColor: const AlwaysStoppedAnimation(Colors.red),
                        ),
                      if (downloadTable.status != DownloadStatus.FAIL &&
                          downloadTable.status != DownloadStatus.FINISH)
                        if (task == null)
                          const LinearProgressIndicator(value: null)
                        else
                          Obx(() => LinearProgressIndicator(
                              value: task.progress.value))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardImage(Dio dio, String url) {
    return DioImage(
      dio: dio,
      imageUrlBuilder: () => Future.value(url),
    );
  }
}
