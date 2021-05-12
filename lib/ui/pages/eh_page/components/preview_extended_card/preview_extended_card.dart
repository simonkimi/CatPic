import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PreviewExtendedCard extends StatelessWidget {
  const PreviewExtendedCard({
    Key? key,
    required this.preViewModel,
    required this.adapter,
  }) : super(key: key);

  final PreViewModel preViewModel;
  final EHAdapter adapter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 110,
                height: 150,
                child: DioImage(
                  dio: adapter.dio,
                  imageUrl: preViewModel.previewImg,
                  imageBuilder: (_, data) => SizedBox(
                    child: SizedBox(
                      width: 110,
                      height: 150,
                      child: Image(
                        image: MemoryImage(data, scale: 0.5),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 140),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              preViewModel.title,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              preViewModel.uploader,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .color,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              children: preViewModel.keyTags.map((e) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: e.color == 0
                                        ? const Color(0xFFEFEEF1)
                                        : Color(0xFF000000 | e.color),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Text(
                                      e.tag,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 43),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RatingBar.builder(
                                    itemSize: 16,
                                    ignoreGestures: true,
                                    initialRating: preViewModel.stars,
                                    onRatingUpdate: (value) {},
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 3),
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: fromEhTag(preViewModel.tag),
                                    ),
                                    child: Text(
                                      preViewModel.tag,
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${preViewModel.pages}P',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      color: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .color),
                                ),
                                Text(
                                  preViewModel.uploadTime,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      color: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .color),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}
