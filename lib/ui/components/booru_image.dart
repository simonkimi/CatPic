// import 'package:catpic/utils/image/cached_dio_image_provider.dart';
// import 'package:dio/dio.dart';
// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
//
// typedef LoadingWidgetBuilder = Widget Function(
//     BuildContext context, ImageChunkEvent chunkEvent);
//
// typedef ErrorBuilder = Widget Function(BuildContext context, Object err);
//
// class BooruImage extends HookWidget {
//   const BooruImage({
//     Key key,
//     this.imgUrl,
//     this.dio,
//     this.loadingWidgetBuilder,
//     this.width,
//     this.height,
//   }) : super(key: key);
//
//   final LoadingWidgetBuilder loadingWidgetBuilder;
//
//   final String imgUrl;
//   final Dio dio;
//   final int width;
//   final int height;
//
//   @override
//   Widget build(BuildContext context) {
//     final _controller = useAnimationController(
//         duration: const Duration(milliseconds: 500),
//         lowerBound: 0.2,
//         upperBound: 1.0);
//
//     return ExtendedImage(
//       image: CachedDioImageProvider(dio: dio, url: imgUrl, cachedKey: imgUrl),
//       enableMemoryCache: true,
//       loadStateChanged: (state) {
//         if (state.extendedImageLoadState == LoadState.loading) {
//           _controller?.reset();
//           return loadingWidgetBuilder(context, state.loadingProgress);
//         } else if (state.extendedImageLoadState == LoadState.completed) {
//           _controller.forward();
//           return FadeTransition(
//             opacity: _controller,
//             child: ExtendedRawImage(
//               image: state.extendedImageInfo?.image,
//             ),
//           );
//         } else if (state.extendedImageLoadState == LoadState.failed) {
//           _controller.reset();
//           return AspectRatio(
//             aspectRatio: width / height,
//             child: Center(
//               child: InkWell(
//                 onTap: () {
//                   state.reLoadImage();
//                 },
//                 child: const Center(
//                   child: Text('重新加载'),
//                 ),
//               ),
//             ),
//           );
//         }
//         return null;
//       },
//     );
//   }
// }
