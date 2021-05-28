import 'package:catpic/ui/pages/eh_page/preview_page/store/read_store.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/store/store.dart';
import 'package:flutter/material.dart';

class EhReadPage extends StatelessWidget {
  EhReadPage({
    Key? key,
    required this.store,
    required this.startIndex,
  })  : readStore = ReadStore(
          currentIndex: startIndex,
        ),
        super(key: key);

  final EhGalleryStore store;
  final int startIndex;

  final ReadStore readStore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: buildImg(),
      extendBody: true,
    );
  }

  Widget buildImg() {
    return Container(
      color: Colors.black,
      child: buildEhPageSlider(),
    );
  }

  Widget buildEhPageSlider() {
    return Container();
  }
}
