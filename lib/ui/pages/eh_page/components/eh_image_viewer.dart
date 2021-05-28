import 'package:catpic/ui/pages/eh_page/preview_page/store/store.dart';
import 'package:catpic/utils/dio_image_provider.dart';
import 'package:flutter/material.dart';

class EhImageViewer extends StatefulWidget {
  const EhImageViewer({
    Key? key,
    required this.store,
  }) : super(key: key);

  final EhGalleryStore store;

  @override
  _EhImageViewerState createState() => _EhImageViewerState();
}

class _EhImageViewerState extends State<EhImageViewer> {
  final imageProvider = <int, DioImageProvider?>{};

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
