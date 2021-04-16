import 'dart:convert';

import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/download.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/ui/components/cached_image.dart';
import 'package:catpic/ui/pages/download_page/store/download_store.dart';
import 'package:catpic/ui/pages/image_view_page/image_view_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:catpic/utils/utils.dart';

class DownloadManagerPage extends StatelessWidget {
  final _store = DownloadStore();

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
    return FutureBuilder<List<WebsiteTableData>>(  // 方便由id获取WebsiteEntity, 以构造Dio
      future: DatabaseHelper().websiteDao.getAll(),
      initialData: const [],
      builder: (_, websiteList) {
        return StreamBuilder<List<DownloadTableData>>(  // 获取下载历史数据库
            stream: DatabaseHelper().downloadDao.getAllStream(),
            initialData: const [],
            builder: (_, downloadList) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder<List<DownLoadTask>>(  // 获取下载列表, 此数据每秒更新一次
                      stream: _store.downloadProgressStream,
                      initialData: const [],
                      builder: (_, downloadingTask) {
                        final taskList = downloadingTask.data!;
                        return Column(
                          children: downloadList.data!
                              .where((e) => e.status != DownloadStatus.FINISH)
                              .map((e) {
                            final task = taskList.firstOrNull(
                                (element) => element.database.id == e.id);
                            return _buildDownloadCard(
                                context, websiteList.data!, e, task?.progress);
                          }).toList(),
                        );
                      },
                    ),
                    Column(
                      children: downloadList.data!
                          .where((e) => e.status == DownloadStatus.FINISH)
                          .map((e) => _buildDownloadCard(
                              context, websiteList.data!, e, 1))
                          .toList(),
                    )
                  ],
                ),
              );
            });
      },
    );
  }

  Widget _buildDownloadCard(BuildContext context, List<WebsiteTableData> list,
      DownloadTableData data, double? progress) {
    final dio = DioBuilder.build(
        list.firstOrNull((element) => element.id == data.websiteId));
    final uri = Uri.parse(data.imgUrl);
    final subtitle = '${uri.scheme}://${uri.host}/';

    return Container(
      height: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewPage(
                dio: dio,
                booruPost: BooruPost.fromJson(jsonDecode(data.booruJson)),
              ),
            ),
          );
        },
        child: Card(
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
                      Text(subtitle,
                          style: Theme.of(context).textTheme.subtitle2),
                      const SizedBox(height: 5),
                      Text(data.createTime.toString(),
                          style: Theme.of(context).textTheme.subtitle2),
                      const SizedBox(height: 5),
                      if (progress != 1)
                        LinearProgressIndicator(value: progress)
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
