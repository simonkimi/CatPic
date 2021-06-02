import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/themes.dart';
import 'package:catpic/ui/components/dark_image.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:catpic/ui/components/nullable_hero.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:catpic/utils/utils.dart';

class PreviewExtendedCard extends StatelessWidget {
  const PreviewExtendedCard({
    Key? key,
    required this.previewModel,
    required this.adapter,
  }) : super(key: key);

  final PreViewItemModel previewModel;
  final EHAdapter adapter;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return EhPreviewPage(
                  imageCount: previewModel.pages,
                  previewAspectRatio:
                      previewModel.previewHeight / previewModel.previewWidth,
                  previewModel: previewModel,
                  heroTag: '${previewModel.gid}${previewModel.gtoken}',
                  adapter: adapter,
                );
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildImage(context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 140),
                    child: Stack(
                      children: [
                        buildCardInfo(context),
                        buildStar(context),
                        buildPageAndTime(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned buildPageAndTime(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
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
      ),
    );
  }

  Positioned buildStar(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Row(
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
    );
  }

  Column buildCardInfo(BuildContext context) {
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
        const SizedBox(height: 43),
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
              e.tag,
              style: TextStyle(
                  fontSize: 11,
                  color: e.color == 0
                      ? isDarkMode(context)
                          ? Colors.white
                          : Colors.black
                      : Color(0xFF000000 | e.color).isDark()
                          ? Colors.white
                          : Colors.black),
            ),
          ),
        );
      }).toList(),
    );
  }

  SizedBox buildImage(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 150,
      child: DioImage(
        dio: adapter.dio,
        imageUrl: previewModel.previewImg,
        imageBuilder: (_, data) => SizedBox(
          child: Container(
            color: isDarkMode(context) ? const Color(0xFF424242) : null,
            child: SizedBox(
              width: 110,
              height: 150,
              child: Center(
                child: AspectRatio(
                  aspectRatio:
                      previewModel.previewHeight / previewModel.previewWidth,
                  child: NullableHero(
                    tag: '${previewModel.gid}${previewModel.gtoken}',
                    child: DarkImage(
                      image: MemoryImage(data, scale: 0.5),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
