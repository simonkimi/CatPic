import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:catpic/ui/components/post_preview_card.dart';
import 'package:catpic/ui/pages/post_image_view/post_image_view.dart';
import 'package:flutter/material.dart';
import 'package:catpic/main.dart';

import '../../../i18n.dart';

class PoolPreviewPage extends StatelessWidget {
  const PoolPreviewPage({
    Key? key,
    required this.booruPool,
    required this.adapter,
  }) : super(key: key);

  final BooruPool booruPool;
  final BooruAdapter adapter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: booruPool.fetchPosts(adapter.client),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          late Widget child;
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError)
            child = buildPreviewGrid();
          else
            child = SliverFixedExtentList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return const Center(child: CircularProgressIndicator());
                },
                childCount: 1,
              ),
              itemExtent: 100.0,
            );

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(booruPool.name.replaceAll('', '\u{200B}')),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  tooltip: I18n.of(context).back,
                ),
              ),
              child,
            ],
          );
        },
      ),
    );
  }

  SliverGrid buildPreviewGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: settingStore.previewRowNum,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 2 / 3,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final onCardTap = () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return PostImageViewPage.builder(
                dio: adapter.dio,
                index: index,
                futureItemBuilder: (index) async {
                  return await booruPool.fromIndex(adapter.client, index);
                },
                itemCount: booruPool.postCount);
          }));
        };

        return PostPreviewCard(
          title: '# $index',
          hasSize: true,
          body: DioImage(
            dio: adapter.dio,
            imageUrlBuilder: () async {
              return (await booruPool.fromIndex(adapter.client, index))
                  .getPreviewImg();
            },
            imageBuilder: (context, data) {
              return InkWell(
                onTap: onCardTap,
                child: Image(image: MemoryImage(data)),
              );
            },
            loadingBuilder: (context, chunkEvent) {
              return InkWell(
                onTap: onCardTap,
                child: Container(
                  color: Colors.primaries[index % Colors.primaries.length][50],
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: (chunkEvent.expectedTotalBytes == null ||
                                chunkEvent.expectedTotalBytes == 0)
                            ? 0
                            : chunkEvent.cumulativeBytesLoaded /
                                chunkEvent.expectedTotalBytes!,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }, childCount: booruPool.postCount),
    );
  }
}
