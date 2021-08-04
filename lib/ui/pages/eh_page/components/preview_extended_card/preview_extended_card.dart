import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/data/models/gen/eh_preview.pb.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/themes.dart';
import 'package:catpic/ui/components/dark_image.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:catpic/utils/utils.dart';
import 'package:get/get.dart';

typedef FunctionCallback = void Function(Function);

class PreviewExtendedCard extends StatelessWidget {
  const PreviewExtendedCard({
    Key? key,
    required this.previewModel,
    required this.adapter,
    required this.onTap,
    this.heroTag,
    this.progress,
    this.lastWidget,
    this.controllerWidget,
    this.onLoadError,
    this.onRetryTap,
  }) : super(key: key);

  final PreViewItemModel previewModel;
  final EHAdapter adapter;
  final VoidCallback onTap;
  final String? heroTag;
  final Rx<double>? progress;
  final Widget? lastWidget;
  final Widget? controllerWidget;

  final FunctionCallback? onLoadError;
  final VoidCallback? onRetryTap;

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Card buildBody(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildImage(context),
                    buildCardRight(context),
                  ],
                ),
              ),
              if (progress != null)
                SizedBox(
                  height: 2.5,
                  child: Obx(() => LinearProgressIndicator(
                        value: progress?.value,
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildCardRight(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCardInfo(context),
            const Expanded(child: SizedBox()),
            lastWidget ??
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildStar(context),
                    controllerWidget ?? buildPageAndTime(context),
                  ],
                )
          ],
        ),
      ),
    );
  }

  Widget buildPageAndTime(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${previewModel.pages}P',
          style: TextStyle(
              fontSize: 12.5,
              color: Theme.of(context).textTheme.subtitle2!.color),
        ),
        Text(
          previewModel.uploadTime,
          style: TextStyle(
            fontSize: 12.5,
            color: Theme.of(context).textTheme.subtitle2!.color,
          ),
        ),
      ],
    );
  }

  Widget buildStar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      color: Theme.of(context).textTheme.subtitle2!.color),
                )
              ],
            ),
            const SizedBox(height: 3),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 50),
              child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: previewModel.tag.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      previewModel.tag.translate(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildCardInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          previewModel.title,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          previewModel.uploader,
          style: TextStyle(
            color: Theme.of(context).textTheme.subtitle2!.color,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 3),
        buildTagWrap(context),
      ],
    );
  }

  Wrap buildTagWrap(BuildContext context) {
    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: previewModel.keyTags.map((e) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: e.color != 0
                ? Color(0xFF000000 | e.color)
                : isDarkMode(context)
                    ? const Color(0xFF312F32)
                    : const Color(0xFFEFEEF1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Text(
              settingStore.ehTranslate
                  ? e.translate.isNotEmpty
                      ? e.translate
                      : e.tag
                  : e.tag,
              style: TextStyle(
                height: 1,
                fontSize: 11,
                color: e.color == 0
                    ? isDarkMode(context)
                        ? Colors.white
                        : Colors.black
                    : Color(0xFF000000 | e.color).isDark()
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildImage(BuildContext context) {
    var language = previewModel.language;
    if (language == 'speechless') language = '';
    if (language.isNotEmpty) {
      language = language.toUpperCase().substring(0, 2);
    }

    return Stack(
      children: [
        SizedBox(
          width: 90,
          height: 135,
          child: DioImage(
            dio: adapter.dio,
            url: previewModel.previewImg,
            imageBuilder: (context, bytes) {
              return DarkWidget(
                child: Hero(
                  tag: heroTag ?? '${previewModel.gid}${previewModel.gtoken}',
                  child: Image.memory(
                    bytes,
                    width: 90,
                    height: 135,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, reload) {
              onLoadError?.call(reload);
              return InkWell(
                onTap: () {
                  onRetryTap?.call();
                },
                child: const Center(
                  child: Icon(Icons.info),
                ),
              );
            },
          ),
        ),
        if (language.isNotEmpty)
          Positioned(
            right: 1,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(2)),
                child: Text(
                  language,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
