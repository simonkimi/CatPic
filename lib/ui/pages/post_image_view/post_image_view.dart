import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/default_button.dart';
import 'package:catpic/main.dart';
import 'package:catpic/ui/components/multi_image_viewer.dart';
import 'package:catpic/ui/pages/download_page/android_download.dart';
import 'package:catpic/data/store/download/download_store.dart';
import 'package:catpic/ui/pages/post_image_view/booru_comments.dart';
import 'package:catpic/ui/pages/post_image_view/page_slider.dart';
import 'package:catpic/ui/pages/post_image_view/store/store.dart';
import 'package:catpic/ui/pages/search_page/search_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:catpic/ui/components/custom_popup_menu.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:catpic/utils/utils.dart';

typedef ItemBuilder = Future<BooruPost> Function(int index);

class PostImageViewPage extends HookWidget {
  PostImageViewPage.builder({
    Key? key,
    this.adapter,
    required this.index,
    this.onAddTag,
    this.favicon,
    this.dio,
    required this.futureItemBuilder,
    required this.itemCount,
  })   : assert(dio != null || adapter != null),
        store = PostImageViewStore(
          currentIndex: index,
          itemBuilder: futureItemBuilder,
          itemCount: itemCount,
        ),
        pageController = PageController(initialPage: index),
        super(key: key);

  PostImageViewPage.count({
    Key? key,
    this.adapter,
    required this.index,
    this.onAddTag,
    this.favicon,
    this.dio,
    required List<BooruPost> postList,
  })   : assert(dio != null || adapter != null),
        futureItemBuilder = ((index) => Future.value(postList[index])),
        itemCount = postList.length,
        store = PostImageViewStore(
          currentIndex: index,
          itemBuilder: (index) => Future.value(postList[index]),
          itemCount: postList.length,
        ),
        pageController = PageController(initialPage: index),
        super(key: key);

  final BooruAdapter? adapter;
  final Uint8List? favicon;
  final int index;
  final ItemBuilder futureItemBuilder;
  final int itemCount;
  final PostImageViewStore store;
  final ValueChanged<String>? onAddTag;
  final PageController pageController;
  final Dio? dio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: buildImg(),
      bottomNavigationBar: buildBottomBar(),
      extendBody: true,
    );
  }

  Widget buildImg() {
    return Container(
      color: Colors.black,
      child: MultiImageViewer(
        dio: adapter?.dio ?? dio!,
        index: index,
        itemCount: itemCount,
        pageController: pageController,
        futureItemBuilder: (index) async {
          return (await futureItemBuilder(index)).getDisplayImg();
        },
        onIndexChange: (value) async {
          store.setIndex(value);
        },
        onCenterTap: () {
          if (store.pageBarDisplay) {
            store.setPageBarDisplay(false);
            return;
          }
          store.setInfoBarDisplay(!store.infoBarDisplay);
        },
      ),
    );
  }

  Widget buildPopupTag(BooruPost booruPost, BuildContext context) {
    return Wrap(
      spacing: 3,
      children: booruPost.tags['_']!.where((e) => e.isNotEmpty).map((e) {
        return CustomPopupMenu(
          arrowColor: Colors.black87,
          child: Chip(
            key: ValueKey(e),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            label: Text(
              e,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          menuBuilder: (closeMenu) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.black87,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildMenuPopupMenu(
                      icon: Icons.copy,
                      text: I18n.of(context).copy,
                      onTap: () {
                        closeMenu();
                        Clipboard.setData(ClipboardData(text: e));
                        BotToast.showText(
                            text: I18n.of(context).copy_finish(e));
                      },
                    ),
                    const SizedBox(width: 15),
                    buildMenuPopupMenu(
                        icon: Icons.search,
                        text: I18n.of(context).search,
                        onTap: () {
                          closeMenu();
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SearchPage(
                                searchText: e.trim() + ' ',
                              ),
                            ),
                          );
                        }),
                    if (onAddTag != null) const SizedBox(width: 15),
                    if (onAddTag != null)
                      buildMenuPopupMenu(
                        icon: Icons.add,
                        text: I18n.of(context).add,
                        onTap: () {
                          closeMenu();
                          onAddTag?.call(e.trim());
                          BotToast.showText(text: I18n.of(context).add_to_tmp);
                        },
                      ),
                  ],
                ),
              ),
            );
          },
          pressType: PressType.singleClick,
        );
      }).toList(),
    );
  }

  List<Row> buildPopupInfo(BuildContext context, BooruPost booruPost) {
    return [
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
      )
    ];
  }

  Container buildPopupHeader(BuildContext context, BooruPost booruPost) {
    return Container(
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
          '#${booruPost.id}',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          booruPost.createTime,
          style: const TextStyle(color: Color(0xFFEEEEEE)),
        ),
      ),
    );
  }

  Widget buildMenuPopupMenu({
    GestureTapCallback? onTap,
    required IconData icon,
    required String text,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _download(BooruPost booruPost) async {
    try {
      await downloadStore.createDownloadTask(booruPost);
      BotToast.showText(text: I18n.g.download_start);
    } on TaskExisted {
      BotToast.showText(text: I18n.g.download_exist);
    } on DownloadPermissionDenied {
      Navigator.pushNamed(I18n.context, AndroidDownloadPage.route);
    }
  }

  void showAsBottomSheet(BuildContext context, BooruPost booruPost) async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return Container(
            child: Material(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    buildPopupHeader(context, booruPost),
                    const SizedBox(height: 10),
                    ...buildPopupInfo(context, booruPost),
                    buildPopupTag(booruPost, context),
                  ],
                ),
              ),
            ),
          );
        },
        footerBuilder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (adapter != null)
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return BooruCommentsPage(
                            id: store.loadedBooruPost!.id,
                            adapter: adapter!,
                          );
                        }));
                      },
                      child: Icon(
                        Icons.message_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                if (adapter != null) const SizedBox(width: 10),
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
                if (booruPost.source.isNotEmpty) const SizedBox(width: 10),
                if (booruPost.source.isNotEmpty)
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () async {
                        await launch(booruPost.source);
                      },
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
                    onPressed: () {
                      _download(booruPost);
                    },
                    child: const Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget buildBottomBar() {
    final infoController =
        useAnimationController(duration: const Duration(milliseconds: 200));

    final infoHideAni =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 1))
            .animate(infoController);

    final pageController =
        useAnimationController(duration: const Duration(milliseconds: 200))
          ..animateTo(1);
    final pageHideAni =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 1))
            .animate(pageController);

    return Observer(builder: (_) {
      infoController.byValue(store.infoBarDisplay);
      pageController.byValue(store.pageBarDisplay);

      return Stack(
        children: [
          SlideTransition(
            position: infoHideAni,
            child: buildBottomInfoBar(),
          ),
          SlideTransition(
            position: pageHideAni,
            child: buildBottomPageBar(),
          ),
        ],
      );
    });
  }

  Widget buildBottomPageBar() {
    return BottomAppBar(
      color: Colors.transparent,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 20),
          child: Observer(builder: (_) {
            return PageSlider(
              value: store.currentIndex + 1,
              count: itemCount,
              controller: store.pageSliderController,
              onChange: (int value) {
                store.setIndex(value - 1);
                pageController.jumpToPage(value - 1);
              },
            );
          }),
        ),
      ),
    );
  }

  Widget buildBottomInfoBar() {
    return BottomAppBar(
      color: Colors.transparent,
      child: Observer(
        builder: (context) {
          return store.loadedBooruPost == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                          onPressed: () {
                            Navigator.of(I18n.context).pop();
                          },
                        ),
                        InkWell(
                          onTap: () {
                            store.setPageBarDisplay(true);
                            store.setInfoBarDisplay(false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.image,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Observer(
                                  builder: (_) {
                                    return Text(
                                      '${store.currentIndex + 1}/$itemCount',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          iconSize: 16,
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showAsBottomSheet(context, store.loadedBooruPost!);
                          },
                        ),
                        IconButton(
                          iconSize: 16,
                          icon: const Icon(
                            Icons.save_alt,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _download(store.loadedBooruPost!);
                          },
                        ),
                      ],
                    )
                  ],
                );
        },
      ),
    );
  }
}
