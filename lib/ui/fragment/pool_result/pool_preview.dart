import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/network/api/base_client.dart';
import 'package:catpic/ui/components/dio_image.dart';
import 'package:flutter/material.dart';

enum ImageState {
  LOADING,
  ERROR,
  FINISH,
}

class PoolPreviewImage extends StatefulWidget {
  const PoolPreviewImage({
    Key? key,
    required this.pool,
    required this.client,
    this.index,
  }) : super(key: key);

  final BooruPool pool;
  final BaseClient client;
  final int? index;

  @override
  _PoolPreviewImageState createState() => _PoolPreviewImageState();
}

class _PoolPreviewImageState extends State<PoolPreviewImage> {
  var _state = ImageState.LOADING;
  late BooruPost poolPost;

  @override
  void initState() {
    super.initState();
    loadPoolImage();
  }

  Future<void> loadPoolImage() async {
    try {
      await widget.pool.getPosts(widget.client);
      poolPost = await widget.pool.fromIndex(widget.client, 0);
      if (mounted)
        setState(() {
          _state = ImageState.FINISH;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _state = ImageState.ERROR;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final failWidget = Container(
      color: Colors.primaries[(widget.index ?? 0) % Colors.primaries.length]
          [50],
    );

    switch (_state) {
      case ImageState.LOADING:
        return failWidget;
      case ImageState.ERROR:
        return failWidget;
      case ImageState.FINISH:
        return DioImage(
          imageUrl: poolPost.previewURL,
          dio: widget.client.dio,
          imageBuilder: (_, imageData) {
            return Image(
              image: MemoryImage(imageData),
            );
          },
          loadingBuilder: (context, c) {
            return failWidget;
          },
          errorBuilder: (context, _, reload) {
            return failWidget;
          },
        );
    }
  }
}
