import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/ehentai/eh_website.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:catpic/data/models/gen/eh_preview.pb.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/themes.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/dark_image.dart';
import 'package:catpic/ui/components/icon_text.dart';
import 'package:catpic/ui/components/load_more_manager.dart';
import 'package:catpic/ui/components/nullable_hero.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/pages/eh_page/components/eh_comment/eh_comment.dart';
import 'package:catpic/ui/pages/eh_page/eh_page.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/comment_page.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/store/store.dart';
import 'package:catpic/ui/pages/eh_page/read_page/read_page.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:catpic/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uuid/uuid.dart';

import 'gallery_preview.dart';

enum GalleryAction {
  REFRESH,
}

class EhPreviewPage extends StatelessWidget {
  EhPreviewPage({
    Key? key,
    this.heroTag,
    this.previewAspectRatio,
    required this.adapter,
    this.previewModel,
    this.galleryBase,
  })  : store = EhGalleryStore(
          gid: previewModel?.gid ?? galleryBase!.gid,
          gtoken: previewModel?.gtoken ?? galleryBase!.token,
          adapter: adapter,
          previewModel: previewModel,
          previewAspectRatio: previewAspectRatio,
          disposeToken: CancelToken(),
        ),
        assert(galleryBase != null || previewModel != null),
        gid = previewModel?.gid ?? galleryBase!.gid,
        gtoken = previewModel?.gtoken ?? galleryBase!.token,
        super(key: key);

  final PreViewItemModel? previewModel;
  final GalleryBase? galleryBase;
  final String? heroTag;
  final EHAdapter adapter;
  final double? previewAspectRatio;
  final EhGalleryStore store;

  final String gid;
  final String gtoken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Observer(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop();
              store.dispose();
              return true;
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: store.previewModel != null
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          // 构建图片, 标题, 分数, tag, 阅读按钮
                          buildPreviewTitle(context),
                          const Divider(),
                          // 构建下面的需要加载的数据
                          buildNeedLoading(context),
                        ],
                      ),
                    )
                  : store.lastException == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : EmptyWidget(
                          onTap: store.loadBaseModel,
                          errMsg: store.lastException!.toString(),
                        ),
            ),
          );
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: appBarBackButton(),
      actions: [
        PopupMenuButton<GalleryAction>(
          icon: const Icon(
            Icons.more_vert_outlined,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onSelected: (value) async {
            switch (value) {
              case GalleryAction.REFRESH:
                DB().galleryCacheDao.remove(gid, gtoken).then((value) {
                  store.refresh();
                });
            }
          },
          itemBuilder: (context) {
            return [
              buildPopupMenuItem(
                context: context,
                icon: Icons.refresh,
                value: GalleryAction.REFRESH,
                text: I18n.of(context).refresh,
              ),
            ];
          },
        ),
      ],
    );
  }

  PopupMenuItem<T> buildPopupMenuItem<T>({
    required BuildContext context,
    required IconData icon,
    required String text,
    required T value,
  }) {
    return PopupMenuItem<T>(
      value: value,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).textTheme.subtitle1!.color,
          ),
          const SizedBox(width: 20),
          Text(text),
        ],
      ),
    );
  }

  Widget buildNeedLoading(BuildContext context) {
    return LoadMoreManager(
      store: store,
      body: store.isLoaded
          ? Column(
              children: [
                buildInfoBarRow(context),
                const Divider(),
                buildTagTitle(context),
                buildTagList(context),
                const Divider(),
                buildCommentTitle(context),
                buildCommentList(context),
                const Divider(),
                buildPreviewList(context),
              ],
            )
          : const SizedBox(),
    );
  }

  Padding buildCommentTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            I18n.of(context).star_and_comment,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const Expanded(child: SizedBox()),
          Row(
            children: [
              RatingBar.builder(
                itemSize: 14,
                ignoreGestures: true,
                initialRating:
                    store.galleryModel?.star ?? store.previewModel?.stars ?? 0,
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
                (store.galleryModel?.star ?? store.previewModel?.stars ?? 0)
                        .toString() +
                    ' (${store.galleryModel?.starMember.toString() ?? '0'})',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.subtitle2!.color,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Padding buildTagTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            I18n.of(context).tag,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildPreviewTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 150),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildLeftImage(),
                  const SizedBox(width: 8),
                  buildRightInfo(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildRightInfo(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(context),
              const SizedBox(height: 5),
              buildUploader(context),
              const SizedBox(height: 5),
              buildTypeTag(context),
              const SizedBox(height: 5),
            ],
          ),
          Observer(
            builder: (context) {
              return Row(
                children: [
                  buildReadButton(context),
                  const Expanded(child: SizedBox()),
                  if (store.isLoaded &&
                      (store.galleryModel?.updates.isNotEmpty ?? false))
                    buildUpdatesButton(context),
                  if (store.isLoaded) buildFavouriteButton(context),
                  if (store.isLoaded) buildDownloadButton(),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildUpdatesButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final gallery = await showUpdateMenu(context);
        if (gallery != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return EhPreviewPage(
              adapter: adapter,
              heroTag: const Uuid().v4(),
              galleryBase: GalleryBase(gid: gallery.gid, token: gallery.token),
            );
          }));
        }
      },
      child: const Icon(Icons.update),
      style: ButtonStyle(
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 10, vertical: 2)),
          minimumSize: MaterialStateProperty.all(const Size(0, 0)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: MaterialStateProperty.all(Colors.orange)),
    );
  }

  Widget buildDownloadButton() {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder<EhDownloadTableData?>(
        future: DB().ehDownloadDao.getByGid(store.gid, store.gtoken),
        builder: (context, snapshot) {
          return Observer(
            builder: (context) {
              return TextButton(
                onPressed: () async {
                  if (snapshot.data == null) {
                    final value = await store.onDownloadClick();
                    if (value)
                      BotToast.showText(text: I18n.of(context).download_start);
                    setState(() {});
                  }
                },
                child: store.isDownloadLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    : Icon(snapshot.data == null
                        ? Icons.cloud_download_outlined
                        : Icons.cloud_download),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2)),
                  minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
            },
          );
        },
      );
    });
  }

  Widget buildFavouriteButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (store.favcat != -1) {
          final result = await store.onFavouriteClick(-1);
          if (result) {
            BotToast.showText(text: I18n.of(context).favourite_del);
          }
        } else {
          final result = await getFavcat(context);
          if (result != null) {
            final rsp = await store.onFavouriteClick(result);
            if (rsp) {
              BotToast.showText(
                  text: I18n.of(context).favourite_to(
                      (adapter.websiteEntity.favouriteList)
                              .get((e) => e.favcat == store.favcat)
                              ?.tag ??
                          ''));
            }
          }
        }
      },
      child: store.isFavLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : Icon(store.favcat == -1 ? Icons.favorite_outline : Icons.favorite),
      style: ButtonStyle(
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 10, vertical: 2)),
          minimumSize: MaterialStateProperty.all(const Size(0, 0)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: MaterialStateProperty.all(store.favcat.favcatColor)),
    );
  }

  Future<int?> getFavcat(BuildContext context) => showDialog<int>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  I18n.of(context).favourite,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const Divider(height: 0),
              ...adapter.websiteEntity.favouriteList.map((e) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop(e.favcat);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: e.favcat.favcatColor,
                        ),
                        const SizedBox(width: 5),
                        Text(e.tag),
                        const Expanded(child: SizedBox()),
                        Text(e.count.toString()),
                      ],
                    ),
                  ),
                );
              })
            ],
          ),
        );
      });

  Future<GalleryUpdate?> showUpdateMenu(BuildContext context) =>
      showDialog<GalleryUpdate>(
          context: context,
          builder: (context) {
            return Dialog(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text(
                        I18n.of(context).update,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const Divider(height: 0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: store.galleryModel!.updates.map((e) {
                        return ListTile(
                          title: Text(e.title),
                          subtitle: Text(e.updateTime),
                          onTap: () {
                            Navigator.of(context).pop(e);
                          },
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            );
          });

  Text buildUploadTime(BuildContext context) {
    return Text(
      store.previewModel!.uploadTime,
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).textTheme.subtitle2!.color,
      ),
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
              right: 15,
              left: 15,
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
            itemCount: min(store.observableList.length, 80),
            itemBuilder: (context, index) {
              final image = store.observableList[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return EhReadPage(
                      store: store.readStore,
                      startIndex: index,
                    );
                  }));
                },
                child: PostPreviewCard(
                  hasSize: true,
                  body: Center(
                    child: Container(
                      child: DarkWidget(
                        child: AspectRatio(
                          aspectRatio: 100 / image.height,
                          child: image.isLarge
                              ? ExtendedImage(
                                  image: DioImageProvider(
                                    dio: store.adapter.dio,
                                    url: image.imageUrl,
                                  ),
                                )
                              : ExtendedImage(
                                  image: store.normalImageMap[image.imageUrl]!,
                                  loadStateChanged: (state) {
                                    if (state.extendedImageLoadState ==
                                        LoadState.completed) {
                                      return ExtendedRawImage(
                                        image: state.extendedImageInfo?.image,
                                        width: 200,
                                        height: image.height * 2,
                                        fit: BoxFit.fill,
                                        sourceRect: Rect.fromLTWH(
                                          image.positioning + .0,
                                          0,
                                          100,
                                          image.height + .0,
                                        ),
                                        scale: 0.5,
                                      );
                                    }
                                    return null;
                                  },
                                ),
                        ),
                      ),
                    ),
                  ),
                  title: (index + 1).toString(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              store.galleryModel!.imageCount <=
                      min(80, store.galleryModel!.imageCountInOnePage)
                  ? I18n.of(context).no_preview
                  : I18n.of(context).show_more_preview,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
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
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: store.galleryModel!.comments.isNotEmpty
            ? Column(
                children: [
                  ...store.galleryModel!.comments.take(2).map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: EhComment(
                        model: e,
                        maxLine: 10,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EhCommentPage(store: store),
                          ));
                        },
                      ),
                    );
                  }).toList(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      store.galleryModel!.comments.length <= 2
                          ? I18n.of(context).no_comment
                          : I18n.of(context).show_more_comment(
                              (store.galleryModel!.comments.length - 2)
                                  .toString()),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    I18n.of(context).no_comment,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildTagList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Column(
        children: store.galleryModel!.tags.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          settingStore.ehTranslate
                              ? e.keyTranslate.isNotEmpty
                                  ? e.keyTranslate
                                  : e.key
                              : e.key,
                          style: const TextStyle(
                            height: 1,
                            fontSize: 14,
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
                          borderRadius: BorderRadius.circular(8),
                          color: isDarkMode(context)
                              ? const Color(0xFF494949)
                              : const Color(0xFFEFEEF1),
                        ),
                        child: InkWell(
                          onTap: () {
                            var tag = e.value;
                            if (tag.contains(' ')) {
                              tag = '"$tag\$"';
                            }
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return EhPage(
                                searchText: '${e.parent}:$tag',
                                searchType: EHSearchType.INDEX,
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              settingStore.ehTranslate
                                  ? e.translate.isNotEmpty
                                      ? e.translate
                                      : e.value
                                  : e.value,
                              style: const TextStyle(
                                fontSize: 14,
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

  Widget buildInfoBarRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconText(
                      icon: Icons.translate,
                      text: settingStore.ehTranslate
                          ? settingStore.translateMap[store
                                  .galleryModel!.language
                                  .replaceAll('TR', '')
                                  .trim()
                                  .toLowerCase()] ??
                              store.galleryModel!.language
                          : store.galleryModel!.language,
                      style: const TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconText(
                      text: store.galleryModel!.imageCount.toString(),
                      icon: Icons.image_outlined,
                      style: const TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconText(
                      text: store.galleryModel!.fileSize,
                      icon: Icons.file_copy_outlined,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconText(
                icon: Icons.favorite,
                iconColor: Colors.red,
                style: const TextStyle(fontSize: 15),
                text: store.galleryModel!.favorited.toString() +
                    ' ' +
                    (adapter.websiteEntity.favouriteList
                            .get((e) => e.favcat == store.favcat)
                            ?.tag ??
                        ''),
              ),
              Text(
                store.previewModel!.uploadTime,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
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

  Widget buildReadButton(BuildContext context) {
    return TextButton(
      onPressed: store.isLoaded
          ? () async {
              final readPage = await DB().ehReadHistoryDao.getPage(gid, gtoken);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return EhReadPage(
                  store: store.readStore,
                  startIndex: readPage,
                );
              }));
            }
          : null,
      child: Row(
        children: [
          const Icon(
            Icons.menu_book_outlined,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(I18n.of(context).read)
        ],
      ),
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return !states.contains(MaterialState.disabled)
              ? Theme.of(context).primaryColor
              : isDarkMode(context)
                  ? const Color(0xFF3A3A3C)
                  : const Color(0xFFD2D1D6);
        }),
        foregroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return !states.contains(MaterialState.disabled)
              ? Colors.white
              : isDarkMode()
                  ? const Color(0xFF929196)
                  : const Color(0xFF8C8B8E);
        }),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 15, vertical: 4)),
        minimumSize: MaterialStateProperty.all(const Size(0, 0)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return InkWell(
      onTap: () {
        final title =
            (store.galleryModel?.title ?? store.previewModel?.title ?? '')
                .replaceAll(RegExp(r'(\[.*?\]|\(.*?\))|{.*?}'), '')
                .trim()
                .split('|')
                .first;
        if (title.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return EhPage(
              searchText: title,
              searchType: EHSearchType.INDEX,
            );
          }));
        }
      },
      child: RichText(
        text: TextSpan(
            text: store.previewModel!.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).textTheme.subtitle1!.color),
            children: const [
              WidgetSpan(
                child: SizedBox(width: 5),
              ),
              WidgetSpan(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 1.5),
                  child: Icon(Icons.search, size: 17),
                ),
              )
            ]),
      ),
    );
  }

  Text buildUploader(BuildContext context) {
    return Text(
      store.previewModel!.uploader,
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).textTheme.subtitle2!.color,
      ),
    );
  }

  Row buildStarBar(BuildContext context) {
    return Row(
      children: [
        RatingBar.builder(
          itemSize: 16,
          ignoreGestures: true,
          initialRating: store.previewModel!.stars,
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
          store.previewModel!.stars.toString(),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.subtitle2!.color,
          ),
        )
      ],
    );
  }

  Widget buildTypeTag(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        decoration: BoxDecoration(
          color: store.previewModel!.tag.color,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              store.previewModel!.tag.translate(context),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
    );
  }

  SizedBox buildLeftImage() {
    return SizedBox(
      width: 140,
      child: AspectRatio(
        aspectRatio: max(store.previewAspectRatio!, 0.5),
        child: NullableHero(
          tag: heroTag ?? '$gid$gtoken',
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
                url: store.previewModel!.previewImg,
              ),
              enableLoadState: true,
              loadStateChanged: (state) {
                if (state.extendedImageLoadState == LoadState.completed) {
                  return DarkWidget(child: state.completedWidget);
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }
}
