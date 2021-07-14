import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText({
    Key? key,
    required this.icon,
    this.iconColor,
    required this.text,
    this.style,
  }) : super(key: key);

  final IconData icon;
  final Color? iconColor;
  final String text;

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: (style?.fontSize ?? 15) + 1,
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: style ?? const TextStyle(fontSize: 15),
        )
      ],
    );
  }
}
