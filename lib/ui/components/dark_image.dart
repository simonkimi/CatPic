import 'package:catpic/themes.dart';
import 'package:flutter/material.dart';

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
    return !isDarkMode(context)
        ? Image(
            image: image,
            fit: fit,
          )
        : Stack(
            children: [
              Image(image: image),
              Container(
                color: Colors.black26,
              ),
            ],
          );
  }
}
