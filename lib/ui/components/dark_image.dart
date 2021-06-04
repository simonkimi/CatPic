import 'package:catpic/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:catpic/main.dart';

class DarkImage extends StatelessWidget {
  const DarkImage({
    Key? key,
    required this.image,
    this.fit,
    this.loadingBuilder,
  }) : super(key: key);
  final ImageProvider image;
  final BoxFit? fit;
  final ImageLoadingBuilder? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) => settingStore.darkMask && isDarkMode(context)
            ? Stack(
                children: [
                  Image(
                    image: image,
                    fit: fit,
                    loadingBuilder: loadingBuilder,
                  ),
                  Container(
                    color: Colors.black26,
                  ),
                ],
              )
            : Image(
                image: image,
                fit: fit,
                loadingBuilder: loadingBuilder,
              ));
  }
}

class DarkWidget extends StatelessWidget {
  const DarkWidget({
    Key? key,
    required this.child,
    this.width,
    this.height,
  }) : super(key: key);

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => settingStore.darkMask && isDarkMode(context)
          ? Stack(
              children: [
                child,
                Container(
                  color: Colors.black26,
                  width: width,
                  height: height,
                ),
              ],
            )
          : child,
    );
  }
}
