import 'dart:convert';

import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/download.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/ui/components/cached_image.dart';
import 'package:catpic/ui/pages/post_image_view/post_image_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:catpic/utils/utils.dart';
import 'package:catpic/main.dart';

class DownloadManagerPage extends StatelessWidget {
  static const route = 'DownloadManagerPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: buildBody(context),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        I18n.of(context).download_manager,
        style: const TextStyle(fontSize: 18),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    // 能优化, 先放着, 能用就行
    return FutureBuilder<List<WebsiteTableData>>(
      // 方便由id获取WebsiteEntity, 以构造Dio
      future: DatabaseHelper().websiteDao.getAll(),
      initialData: const [],
      builder: (_, websiteList) {
        return StreamBuilder<List<DownloadTableData>>(
            // 获取下载历史数据库
            stream: DatabaseHelper().downloadDao.getAllStream(),
            initialData: const [],
            builder: (_, downloadList) {
              return StreamBuilder(
                // 获取下载列表, 此数据每2秒更新一次
                stream: Stream.periodic(const Duration(seconds: 2)),
                builder: (_, downloadingTask) {
                  final taskList = downloadStore.downloadingList;
                  return ListView(
                    children: [
                      ...downloadList.data!
                          .where((e) =>
                              e.status == DownloadStatus.PENDING ||
                              e.status == DownloadStatus.FAIL)
                          .map((e) {
                        final task = taskList
                            .get((element) => element.database.id == e.id);
                        return _buildDownloadCard(
                            context, websiteList.data!, e, task?.progress);
                      }),
                      ...downloadList.data!
                          .where((e) => e.status == DownloadStatus.FINISH)
                          .map((e) => _buildDownloadCard(
                              context, websiteList.data!, e, 1))
                    ],
                  );
                },
              );
            });
      },
    );
  }

  Widget _buildDownloadCard(BuildContext context, List<WebsiteTableData> list,
      DownloadTableData data, double? progress) {
    final dio =
        DioBuilder.build(list.get((element) => element.id == data.websiteId));

    return Container(
      height: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostImageViewPage(
                dio: dio,
                index: 1,
                postList: [BooruPost.fromJson(jsonDecode(data.booruJson))],
              ),
            ),
          );
        },
        child: Card(
          key: ValueKey('DownloadCard${data.id}'),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  width: 60,
                  child: buildCardImage(dio, data.previewUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '# ${data.postId}',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        data.imgUrl,
                        style: Theme.of(context).textTheme.subtitle2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(data.createTime.toString(),
                          style: Theme.of(context).textTheme.subtitle2),
                      const SizedBox(height: 5),
                      if (progress != 1 && data.status != DownloadStatus.FAIL)
                        LinearProgressIndicator(value: progress),
                      if (data.status == DownloadStatus.FAIL)
                        LinearProgressIndicator(
                          value: progress,
                          valueColor: const AlwaysStoppedAnimation(Colors.red),
                        )
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
    return CachedDioImage(
      key: ValueKey('Preview$url'),
      imgUrl: url,
      imageBuilder: (context, imgData) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image(
            image: MemoryImage(imgData, scale: 0.1),
            fit: BoxFit.cover,
          ),
        );
      },
      loadingBuilder: (_, progress) {
        return Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              value: ((progress.expectedTotalBytes ?? 0) != 0) &&
                      ((progress.cumulativeBytesLoaded) != 0)
                  ? progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!
                  : 0.0,
              strokeWidth: 2.5,
            ),
          ),
        );
      },
      errorBuilder: (_, err, reload) {
        return const Icon(Icons.error);
      },
    );
  }
}
