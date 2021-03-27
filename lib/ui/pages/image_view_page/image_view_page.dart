import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/generated/l10n.dart';
import 'package:catpic/ui/components/cached_image.dart';
import 'package:catpic/ui/pages/download_page/store/download_store.dart';
import 'package:catpic/data/store/main/main_store.dart';
import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({
    Key? key,
    required this.booruPost,
    required this.heroTag,
    required this.dio,
  }) : super(key: key);

  final BooruPost booruPost;
  final String heroTag;
  final Dio dio;

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage>
    with TickerProviderStateMixin {
  late Animation<double> _doubleClickAnimation;
  late AnimationController _doubleClickAnimationController;
  late VoidCallback _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0, 3.0];

  late bool bottomBarVis = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Observer(builder: (_) => buildImg()),
      bottomNavigationBar: buildBottomBar(),
      extendBody: true,
    );
  }

  Widget _sheetBuilder(BuildContext context, SheetState state) {
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
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.person),
                  ),
                  title: Text(
                    '#${widget.booruPost.creatorId}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    widget.booruPost.createTime,
                    style: const TextStyle(color: Color(0xFFEEEEEE)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${S.of(context).resolution}: ${widget.booruPost.width} x ${widget.booruPost.height}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'ID: ${widget.booruPost.id}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${S.of(context).rating}: ${getRatingText(context, widget.booruPost.rating)}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${S.of(context).score}: ${widget.booruPost.score}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 3,
                children: widget.booruPost.tags['_']!
                    .where((e) => e.isNotEmpty)
                    .map((e) {
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
              child: OutlineButton(
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
              child: OutlineButton(
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
              child: OutlineButton(
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
              child: FlatButton(
                onPressed: () async {
                  try {
                    downloadStore.createDownloadTask(
                        widget.dio, widget.booruPost);
                    BotToast.showText(text: '已经添加到下载列表');
                  } on TaskExistedException {
                    BotToast.showText(text: '任务已存在');
                  }
                },
                color: Theme.of(context).primaryColor,
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

  void showAsBottomSheet() async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: _sheetBuilder,
        footerBuilder: _sheetFootBuilder,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    _writeTag();
  }

  @override
  void dispose() {
    super.dispose();
    _doubleClickAnimationController.dispose();
  }

  Widget buildBottomBar() {
    return BottomAppBar(
      color: Colors.transparent,
      child: Visibility(
        visible: bottomBarVis,
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
                    showAsBottomSheet();
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
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildImg() {
    late String imageUrl;
    switch (settingStore.displayQuality) {
      case ImageQuality.preview:
        imageUrl = widget.booruPost.previewURL;
        break;
      case ImageQuality.sample:
        imageUrl = widget.booruPost.sampleURL;
        break;
      case ImageQuality.raw:
        imageUrl = widget.booruPost.imgURL;
        break;
    }

    return Container(
      color: Colors.black,
      child: CachedDioImage(
        dio: widget.dio,
        imgUrl: imageUrl,
        cachedKey: '$imageUrl${widget.booruPost.md5}',
        imageBuilder: (context, imgData) {
          return Center(
            child: Hero(
              tag: widget.heroTag,
              child: ExtendedImage(
                width: double.infinity,
                height: double.infinity,
                image: MemoryImage(imgData),
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: (state) {
                  return GestureConfig(
                    minScale: 0.9,
                    animationMinScale: 0.7,
                    maxScale: 5.0,
                    animationMaxScale: 5.0,
                    speed: 1.0,
                    inertialSpeed: 100.0,
                    initialScale: 1.0,
                    inPageView: false,
                    initialAlignment: InitialAlignment.center,
                    gestureDetailsIsChanged: (ge) {
                      _showOrHideAppbar(ge);
                    },
                  );
                },
                onDoubleTap: _doubleTap,
              ),
            ),
          );
        },
        errorBuilder: (context, err, reload) {
          return GestureDetector(
            onTap: reload(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    err.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
        loadingBuilder: (_, loadingProgress) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: Builder(
              builder: (context) {
                var progress = loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : 0.0;
                progress = progress.isFinite ? progress : 0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        value: progress == 0 ? null : progress),
                    const SizedBox(
                      height: 20,
                    ),
                    if (progress == 0)
                      Text(
                        S.of(context).connecting,
                        style: const TextStyle(color: Colors.white),
                      )
                    else
                      Text(
                        '${(progress * 100).toStringAsFixed(2)}%',
                        style: const TextStyle(color: Colors.white),
                      )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showOrHideAppbar(GestureDetails? ge) {
    final result = (ge?.totalScale ?? 0.0) < 1.2;
    if (result != bottomBarVis && mounted) {
      setState(() {
        bottomBarVis = result;
      });
    }
  }

  void _doubleTap(ExtendedImageGestureState state) {
    final Offset pointerDownPosition = state.pointerDownPosition!;

    _doubleClickAnimation.removeListener(_doubleClickAnimationListener);
    _doubleClickAnimationController.stop();
    _doubleClickAnimationController.reset();

    final begin = state.gestureDetails?.totalScale ?? 0;
    var endIndex = doubleTapScales.indexOf(begin) + 1;
    if (endIndex >= doubleTapScales.length) {
      endIndex -= doubleTapScales.length;
    }
    final end = doubleTapScales[endIndex];

    _doubleClickAnimationListener = () {
      state.handleDoubleTap(
          scale: _doubleClickAnimation.value,
          doubleTapPosition: pointerDownPosition);
    };
    _doubleClickAnimation = _doubleClickAnimationController
        .drive(Tween<double>(begin: begin, end: end));
    _doubleClickAnimation.addListener(_doubleClickAnimationListener);
    _doubleClickAnimationController.forward();
  }

  Future<void> _writeTag() async {
    final dao = DatabaseHelper().tagDao;
    for (final tags in widget.booruPost.tags.values) {
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
