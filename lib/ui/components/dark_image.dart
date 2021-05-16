import 'package:catpic/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../main.dart';

class DarkImage extends StatelessWidget {
  const DarkImage({
    Key? key,
    required this.image,
    this.fit,
  }) : super(key: key);
  final ImageProvider image;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) => isDarkMode(context) && settingStore.darkMask
            ? Stack(
                children: [
                  Image(image: image),
                  Container(
                    color: Colors.black26,
                  ),
                ],
              )
            : Image(
                image: image,
                fit: fit,
              ));
  }
}

class DarkWidget extends StatelessWidget {
  const DarkWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => isDarkMode(context) && settingStore.darkMask
          ? Stack(
              children: [
                child,
                Container(
                  color: Colors.black26,
                ),
              ],
            )
          : child,
    );
  }
}
