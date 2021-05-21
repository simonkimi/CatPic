import 'package:catpic/data/models/ehentai/gallery_model.dart';
import 'package:catpic/ui/components/dark_image.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_clip/preview_clip.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

const double kScale = 2.0;

class EhPreviewCard extends StatelessWidget {
  const EhPreviewCard({
    Key? key,
    required this.model,
    required this.image,
    required this.title,
  }) : super(key: key);

  final GalleryPreviewImage model;
  final PreviewImage image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return PostPreviewCard(
      hasSize: true,
      body: Obx(
        () => model.loadState.value
            ? DarkWidget(
                child: SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    clipBehavior: Clip.antiAlias,
                    child: CustomPaint(
                      painter: ImageClipper(
                        model.imageData!,
                        height: image.height.toDouble(),
                        width: image.width.toDouble(),
                        offset: image.positioning.toDouble(),
                      ),
                      size: Size(
                        image.width * kScale,
                        image.height * kScale,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ),
      title: title,
    );
  }
}
