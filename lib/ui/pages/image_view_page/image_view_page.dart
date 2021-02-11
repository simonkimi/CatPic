import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/ui/components/cached_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({
    Key key,
    @required this.booruPost,
    @required this.heroTag
  }) : super(key: key);

  final BooruPost booruPost;
  final String heroTag;

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage>
    with TickerProviderStateMixin {
  Animation<double> _doubleClickAnimation;
  AnimationController _doubleClickAnimationController;
  Function _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0, 4.0];

  var bottomBarVis = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: buildImg(),
      bottomNavigationBar: buildBottomBar(),
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
                      '分辨率: ${widget.booruPost.width} x ${widget.booruPost.height}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '作品ID: ${widget.booruPost.id}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '评级: ${getRatingText(context, widget.booruPost.rating)}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '得分: ${widget.booruPost.score}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 3,
                children: widget.booruPost.tags['_'].map((e) {
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
          const SizedBox(
            width: 10,
          ),
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
          const SizedBox(
            width: 10,
          ),
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
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () {},
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
          footerBuilder: _sheetFootBuilder);
    });
  }

  @override
  void initState() {
    super.initState();
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
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
    return CachedDioImage(
      imgUrl: widget.booruPost.imgURL,
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
      errorBuilder: (context, err) {
        return Center(
          child: Text(err.toString()),
        );
      },
      loadingBuilder: (_, progress) {
        return Center(
          child: CircularProgressIndicator(
            value: ((progress.expectedTotalBytes ?? 0) != 0) &&
                    ((progress.cumulativeBytesLoaded ?? 0) != 0)
                ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes
                : 0.0,
          ),
        );
      },
    );
  }

  void _showOrHideAppbar(GestureDetails ge) {
    if (mounted) {
      setState(() {
        bottomBarVis = ge.totalScale < 1.2;
      });
    }
  }

  void _doubleTap(ExtendedImageGestureState state) {
    final Offset pointerDownPosition = state.pointerDownPosition;

    _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);
    _doubleClickAnimationController.stop();
    _doubleClickAnimationController.reset();

    final begin = state.gestureDetails.totalScale;
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
}
