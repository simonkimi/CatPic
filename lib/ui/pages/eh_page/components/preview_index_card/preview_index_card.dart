import 'package:catpic/data/models/gen/eh_preview.pb.dart';
import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:catpic/ui/components/dark_image.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../i18n.dart';
import '../../../../../main.dart';
import '../../../../../themes.dart';

class PreviewIndexCard extends StatelessWidget {
  PreviewIndexCard({
    Key? key,
    required this.previewModel,
    required this.adapter,
    required this.onTap,
    required this.index,
    this.heroTag,
  }) : super(key: key);

  final PreViewItemModel previewModel;
  final EHAdapter adapter;
  final VoidCallback onTap;
  final String? heroTag;
  final int index;

  final retryList = <Function>[];

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                child: DioImage(
                  url: previewModel.previewImg,
                  dio: adapter.dio,
                  imageBuilder: (context, imgData) {
                    return InkWell(
                      onTap: onTap,
                      child: Hero(
                        tag: heroTag ??
                            '${previewModel.gid}${previewModel.gtoken}',
                        child: AspectRatio(
                          aspectRatio: previewModel.previewHeight /
                              previewModel.previewWidth,
                          child: DarkImage(
                              image: MemoryImage(imgData, scale: 0.1)),
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, progress) {
                    return InkWell(
                      onTap: onTap,
                      child: AspectRatio(
                        aspectRatio: previewModel.previewHeight /
                            previewModel.previewWidth,
                        child: Container(
                          color: isDarkMode(context)
                              ? darkColors[index % darkColors.length]
                              : Colors.primaries[
                                  index % Colors.primaries.length][50],
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                value: (progress.expectedTotalBytes == null ||
                                        progress.expectedTotalBytes == 0)
                                    ? 0
                                    : progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!,
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, reload) {
                    retryList.add(reload);
                    return InkWell(
                      onTap: () {
                        for (final retry in retryList) retry();
                        retryList.clear();
                      },
                      child: AspectRatio(
                        aspectRatio: previewModel.previewWidth /
                            previewModel.previewHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.error),
                            const SizedBox(height: 10),
                            Text(I18n.of(context).tap_to_reload),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text(
                previewModel.title.replaceAll('', '\u200B'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
              buildTagWrap(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTagWrap(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: previewModel.keyTags.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
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
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
