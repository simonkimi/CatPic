import 'package:catpic/data/store/setting/setting_store.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/components/dark_image.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/components/pull_to_refresh_footer.dart';
import 'package:catpic/ui/pages/eh_page/components/preview_clip/preview_clip.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/preview_page.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../main.dart';

class GalleryPreview extends StatelessWidget {
  const GalleryPreview({
    Key? key,
    required this.store,
  }) : super(key: key);

  final EhGalleryStore store;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(appBar: buildAppBar(context), body: buildBody());
    });
  }

  Scrollbar buildBody() {
    return Scrollbar(
      showTrackOnHover: true,
      child: FloatingSearchBarScrollNotifier(
        child: SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          footer: CustomFooter(
            builder: buildFooter,
          ),
          controller: store.refreshController,
          header: const MaterialClassicHeader(),
          onRefresh: () {
            if (store.pageTail < 1)
              store.onRefresh();
            else
              store.onLoadPrevious();
          },
          onLoading: store.onLoadMore,
          child: GridView.builder(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
              top: 10,
              bottom: 5,
            ),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: CardSize.of(settingStore.cardSize).toDouble(),
              childAspectRatio: 100 / 142,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: store.observableList.length,
            itemBuilder: _itemBuilder,
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final image = store.observableList[index];
    final galleryPreviewImage = store.imageUrlMap[image.image]!;
    return PostPreviewCard(
      hasSize: true,
      body: Obx(
        () => galleryPreviewImage.loadState.value
            ? DarkWidget(
                child: SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    clipBehavior: Clip.antiAlias,
                    child: CustomPaint(
                      painter: ImageClipper(
                        galleryPreviewImage.imageData!,
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
      title: (index + 1).toString(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: appBarBackButton(),
      centerTitle: true,
      title: Text(
        I18n.of(context).preview,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.more_vert_outlined,
            color: Colors.white,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}