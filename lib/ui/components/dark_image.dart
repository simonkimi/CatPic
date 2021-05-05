import 'package:catpic/themes.dart';
import 'package:flutter/material.dart';

class DarkImage extends StatelessWidget {
  const DarkImage({
    Key? key,
    required this.image,
  }) : super(key: key);
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return !isDarkMode(context)
        ? Image(image: image)
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
