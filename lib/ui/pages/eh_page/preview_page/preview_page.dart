import 'dart:io';
import 'dart:math';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/themes.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/dark_image.dart';
import 'package:catpic/ui/components/nullable_hero.dart';
import 'package:catpic/ui/pages/eh_page/components/eh_comment/eh_comment.dart';
import 'package:catpic/ui/pages/eh_page/components/eh_preview_card/eh_preview_card.dart';
import 'package:catpic/ui/pages/eh_page/eh_page.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/comment_page.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/read_page.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/store/store.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:catpic/main.dart';
import 'gallery_preview.dart';

class EhPreviewPage extends StatelessWidget {
  EhPreviewPage({
    Key? key,
    this.heroTag,
    required this.previewAspectRatio,
    required this.previewModel,
    required this.adapter,
    required this.imageCount,
  })  : store = EhGalleryStore(
          imageCount: imageCount,
          adapter: adapter,
          previewModel: previewModel,
        ),
        super(key: key);

  final PreViewItemModel previewModel;
  final String? heroTag;
  final EHAdapter adapter;
  final double previewAspectRatio;
  final int imageCount;

  final EhGalleryStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: appBarBackButton(),
        title: Text(previewModel.titleJpn ?? ''),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          store.dispose();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildPreviewTitle(context),
              const Divider(),
              Observer(builder: (context) => buildNeedLoading(context)),
            ],
          ),
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
              buildPreviewList(context),
            ],
          );
  }

  Widget buildPreviewList(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return GalleryPreview(store: store);
        }));
      },
      child: Column(
        children: [
          GridView.builder(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
              top: 10,
              bottom: 5,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: CardSize.of(settingStore.cardSize).toDouble(),
              childAspectRatio: 100 / 142,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: min(store.observableList.length, 40),
            itemBuilder: (context, index) {
              final image = store.observableList[index];
              final galleryPreviewImage = store.imageUrlMap[image.image]!;
              return InkWell(
                onTap: () {
                  // TODO 点击预览显示图片
                },
                child: EhPreviewCard(
                  image: image,
                  model: galleryPreviewImage,
                  title: (index + 1).toString(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              store.imageCount <= 40
                  ? I18n.of(context).no_preview
                  : I18n.of(context).show_more_preview,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCommentList(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EhCommentPage(store: store),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: store.commentList.isNotEmpty
            ? Column(
                children: [
                  ...store.commentList.take(2).map((e) {
                    return EhComment(model: e);
                  }).toList(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      store.commentList.length <= 2
                          ? I18n.of(context).no_comment
                          : I18n.of(context).show_more_comment(
                              (store.commentList.length - 2).toString()),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      I18n.of(context).no_comment,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Padding buildTagList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          settingStore.ehTranslate
                              ? e.keyTranslate ?? e.key
                              : e.key,
                          style: const TextStyle(
                            height: 1,
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
                          color: isDarkMode(context)
                              ? const Color(0xFF494949)
                              : const Color(0xFFEFEEF1),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return EhPage(
                                searchText: e.value,
                                searchType: EHSearchType.INDEX,
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              settingStore.ehTranslate
                                  ? e.translate ?? e.value
                                  : e.value,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1,
                              ),
                            ),
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
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                child: AspectRatio(
                  aspectRatio: previewAspectRatio,
                  child: NullableHero(
                    tag: '${previewModel.gid}${previewModel.gtoken}',
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ExtendedImage(
                        fit: BoxFit.fill,
                        image: DioImageProvider(
                          dio: adapter.dio,
                          url: previewModel.previewImg,
                        ),
                        enableLoadState: true,
                        loadStateChanged: (state) {
                          if (state.extendedImageLoadState ==
                              LoadState.completed) {
                            return DarkWidget(child: state.completedWidget);
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 200),
                  child: Column(
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
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              bottom: Platform.isWindows ? 0 : -8,
              left: 148,
              child: Observer(
                builder: (context) {
                  if (store.observableList.isNotEmpty)
                    return TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return EhReadPage(
                            store: store,
                            startIndex: 0,
                          );
                        }));
                      },
                      child: Text(I18n.of(context).read),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(Platform.isWindows
                            ? const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15)
                            : const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2)),
                        minimumSize:
                            MaterialStateProperty.all(const Size(0, 0)),
                      ),
                    );
                  return OutlinedButton(
                    onPressed: () {},
                    child: Text(I18n.of(context).read),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(Platform.isWindows
                          ? const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            )
                          : const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            )),
                      minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
