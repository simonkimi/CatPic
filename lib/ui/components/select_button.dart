import 'package:flutter/material.dart';

import '../../themes.dart';

class SelectButton extends StatelessWidget {
  const SelectButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.activeColor,
    required this.isSelect,
    this.onLongPressed,
  }) : super(key: key);

  final VoidCallback onPressed;
  final VoidCallback? onLongPressed;
  final String text;
  final Color activeColor;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      onLongPress: onLongPressed,
      child: Text(text),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(Size.zero),
        foregroundColor: MaterialStateProperty.all(
          isSelect
              ? Colors.white
              : isDarkMode()
                  ? const Color(0xFF929196)
                  : const Color(0xFF8C8B8E),
        ),
        backgroundColor: MaterialStateProperty.all(
          isSelect
              ? activeColor
              : isDarkMode(context)
                  ? const Color(0xFF3A3A3C)
                  : const Color(0xFFD2D1D6),
        ),
      ),
    );
  }
}
