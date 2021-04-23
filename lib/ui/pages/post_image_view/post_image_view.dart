import 'dart:typed_data';

import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/default_button.dart';
import 'package:catpic/main.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/ui/components/multi_image_viewer.dart';
import 'package:catpic/ui/pages/post_image_view/store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PostImageViewPage extends StatelessWidget {
  const PostImageViewPage({
    Key? key,
    required this.dio,
    required this.index,
    required this.postList,
    this.favicon,
  }) : super(key: key);

  final Dio dio;
  final Uint8List? favicon;
  final int index;
  final List<BooruPost> postList;

  @override
  Widget build(BuildContext context) {
    final store = PostImageViewStore(index);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Observer(builder: (_) => buildImg(store)),
      bottomNavigationBar: buildBottomBar(store),
      extendBody: true,
    );
  }

  Widget _sheetBuilder(
      BuildContext context, SheetState state, PostImageViewStore store) {
    return Observer(builder: (_) {
      final booruPost = postList[store.index];
      return Container(
        child: Material(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ListTile(
                    leading: favicon?.isNotEmpty ?? false
                        ? CircleAvatar(
                            child: ClipOval(
                              child: Image(
                                  image: MemoryImage(favicon!, scale: 0.1),
                                  fit: BoxFit.fill),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(Icons.person),
                          ),
                    title: Text(
                      '#${booruPost.creatorId}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      booruPost.createTime,
                      style: const TextStyle(color: Color(0xFFEEEEEE)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${I18n.of(context).resolution}: ${booruPost.width} x ${booruPost.height}',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'ID: ${booruPost.id}',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${I18n.of(context).rating}: ${getRatingText(context, booruPost.rating)}',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${I18n.of(context).score}: ${booruPost.score}',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 3,
                  children:
                      booruPost.tags['_']!.where((e) => e.isNotEmpty).map((e) {
                    return FilterChip(
                      key: ValueKey(e),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      label: Text(
                        e,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      onSelected: (v) {},
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _sheetFootBuilder(BuildContext context, SheetState state) {
    return StatefulBuilder(builder: (context, setLocalState) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {},
                child: Icon(
                  Icons.message_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {},
                child: Icon(
                  Icons.favorite_outline,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () {},
                child: Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: DefaultButton(
                onPressed: _download,
                child: const Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _download() async {
    // try {
    //   await downloadStore.createDownloadTask(booruPost);
    //   BotToast.showText(text: I18n
    //       .of(context)
    //       .download_start);
    // } on TaskExisted {
    //   BotToast.showText(text: I18n
    //       .of(context)
    //       .download_exist);
    // } on DownloadPermissionDenied {
    //   Navigator.pushNamed(context, AndroidDownloadPage.route);
    // }
  }

  void showAsBottomSheet(BuildContext context, PostImageViewStore store) async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) => _sheetBuilder(context, state, store),
        footerBuilder: _sheetFootBuilder,
      );
    });
  }

  Widget buildBottomBar(PostImageViewStore store) {
    return Observer(builder: (_) {
      return BottomAppBar(
        color: Colors.transparent,
        child: Visibility(
          visible: store.bottomBarVis,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: 16,
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showAsBottomSheet(_, store);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    iconSize: 16,
                    icon: const Icon(
                      Icons.save_alt,
                      color: Colors.white,
                    ),
                    onPressed: _download,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget buildImg(PostImageViewStore store) {
    final imageBase = postList.map((e) {
      late String imgUrl;
      switch (settingStore.displayQuality) {
        case ImageQuality.preview:
          imgUrl = e.previewURL;
          break;
        case ImageQuality.sample:
          imgUrl = e.sampleURL;
          break;
        case ImageQuality.raw:
          imgUrl = e.imgURL;
          break;
      }
      return ImageBase(
        imgUrl: imgUrl,
        cachedKey: imgUrl,
        heroTag: '${e.id}|${e.md5}',
      );
    }).toList();

    return Container(
      color: Colors.black,
      child: MultiImageViewer(
        dio: dio,
        index: index,
        images: imageBase,
        onScale: (result) {
          if (store.bottomBarVis != result) {
            store.setBottomBarVis(result);
          }
        },
        onIndexChange: (value) {
          store.setIndex(value);
          _writeTag(value);
        },
      ),
    );
  }

  Future<void> _writeTag(int index) async {
    final dao = DatabaseHelper().tagDao;
    for (final tags in postList[index].tags.values) {
      for (final tagStr in tags) {
        if (tagStr.isNotEmpty) {
          await dao.insert(TagTableCompanion.insert(
            website: mainStore.websiteEntity!.id,
            tag: tagStr,
          ));
        }
      }
    }
  }
}
