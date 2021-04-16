import 'dart:convert';

import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/ui/components/cached_image.dart';
import 'package:catpic/ui/pages/image_view_page/image_view_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DownloadManagerPage extends StatelessWidget {
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
        I18n
            .of(context)
            .download_manager,
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
    return StreamBuilder<List<DownloadTableData>>(
      stream: DatabaseHelper().downloadDao.getAllStream(),
      initialData: const [],
      builder: (ctx, sn) {
        return FutureBuilder<List<WebsiteTableData>>(
          future: DatabaseHelper().websiteDao.getAll(),
          initialData: null,
          builder: (ctx, sn2) {
            return ListView(
              children: sn.data!
                  .map((e) => _buildDownloadCard(context, sn2.data!, e))
                  .toList(),
            );
          },
        );
      },
    );
  }

  Widget _buildDownloadCard(BuildContext context,
      List<WebsiteTableData> list, DownloadTableData data) {
    Dio? dio;
    final entities = list.where((element) => element.id == data.websiteId);
    if (entities.isNotEmpty) {
      dio = DioBuilder.build(entities.first);
    }
    return Container(
      height: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ImageViewPage(
                    dio: dio ?? Dio(),
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
                  child: dio != null
                      ? buildCardImage(dio, data.previewUrl)
                      : const SizedBox(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.fileName),
                      Text(Uri
                          .parse(data.imgUrl)
                          .host)
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
