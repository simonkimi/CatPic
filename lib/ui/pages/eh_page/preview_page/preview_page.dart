import 'dart:math';

import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/nullable_hero.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_clip/preview_clip.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/store/store.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../../main.dart';

class EhPreviewPage extends StatelessWidget {
  EhPreviewPage({
    Key? key,
    this.heroTag,
    required this.previewModel,
    required this.adapter,
  })   : store = EhGalleryStore(
          adapter: adapter,
          previewModel: previewModel,
        ),
        super(key: key);

  final PreViewItemModel previewModel;
  final String? heroTag;
  final EHAdapter adapter;

  final EhGalleryStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: appBarBackButton(),
        title: Text(previewModel.titleJpn ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          store.dispose();
          return true;
        },
        child: Observer(
          builder: (context) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  buildPreviewTitle(context),
                  const Divider(),
                  buildNeedLoading(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildNeedLoading(BuildContext context) {
    return store.observableList.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              buildInfoBarRow(context),
              const Divider(),
              buildTagList(context),
              const Divider(),
              buildCommentList(context),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent:
                        CardSize.of(settingStore.cardSize).toDouble(),
                  ),
                  itemCount: min(store.observableList.length, 40),
                  itemBuilder: (context, index) {
                    final image = store.observableList[index];
                    final galleryPreviewImage = store.imageUrlMap[image.image]!;
                    return PostPreviewCard(
                      body: Obx(
                        () => galleryPreviewImage.loadState.value
                            ? CustomPaint(
                                painter: ImageClipper(
                                  galleryPreviewImage.imageData!,
                                  height: image.height.toDouble(),
                                  width: 100,
                                  offset: image.positioning.toDouble(),
                                ),
                              )
                            : const SizedBox(
                                child: Center(
                                  child: Icon(Icons.account_balance_wallet),
                                ),
                              ),
                      ),
                      title: (index + 1).toString(),
                    );
                  },
                ),
              )
            ],
          );
  }

  Padding buildCommentList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: store.commentList.isNotEmpty
          ? Column(
              children: store.commentList.take(2).map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.username,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .color,
                              ),
                            ),
                            Text(
                              e.commentTime,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            text: e.comment,
                            style: Theme.of(context).textTheme.bodyText2,
                            children: [
                              if (e.score != -99999)
                                TextSpan(
                                  text: (e.score >= 0 ? '   +' : '   ') +
                                      e.score.toString(),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .color,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                I18n.of(context).no_comment,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  Padding buildTagList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: store.tagList.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          e.key,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    spacing: 3,
                    runSpacing: 3,
                    children: e.value.map((e) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFFEFEEF1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            e,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Row buildInfoBarRow(BuildContext context) {
    return Row(
      children: [
        buildInfoBar(
          store.language,
          Text(
            I18n.of(context).language,
            style:
                TextStyle(color: Theme.of(context).textTheme.subtitle2!.color),
          ),
        ),
        const SizedBox(
          width: 1,
          height: 30,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    store.imageCount.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Icon(
                    Icons.image_sharp,
                    size: 15,
                  ),
                ],
              ),
              Text(
                I18n.of(context).page,
                style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle2!.color),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 1,
          height: 30,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
          ),
        ),
        buildInfoBar(
          store.fileSize,
          Text(
            I18n.of(context).size,
            style: TextStyle(
              color: Theme.of(context).textTheme.subtitle2!.color,
            ),
          ),
        ),
        const SizedBox(
          width: 1,
          height: 30,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    store.favouriteCount.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Icon(
                    Icons.favorite,
                    size: 15,
                  ),
                ],
              ),
              Text(
                I18n.of(context).favourite,
                style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle2!.color),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildInfoBar(String title, Widget subtitle) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle,
        ],
      ),
    );
  }

  Widget buildPreviewTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              height: 200,
              child: NullableHero(
                tag: '${previewModel.gid}${previewModel.gtoken}',
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(5),
                  ),
                  child: Center(
                    child: ExtendedImage(
                      image: DioImageProvider(
                        dio: adapter.dio,
                        url: previewModel.previewImg,
                      ),
                      enableLoadState: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 200),
              child: Stack(
                children: [
                  Positioned(
                    bottom: -8,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(I18n.of(context).read),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2)),
                        minimumSize:
                            MaterialStateProperty.all(const Size(0, 0)),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        previewModel.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        previewModel.uploader,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color:
                                Theme.of(context).textTheme.subtitle2!.color),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          RatingBar.builder(
                            itemSize: 16,
                            ignoreGestures: true,
                            initialRating: previewModel.stars,
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
                            previewModel.stars.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .color),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: fromEhTag(previewModel.tag),
                        ),
                        child: Text(
                          previewModel.tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
