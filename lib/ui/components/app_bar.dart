import 'package:catpic/i18n.dart';
import 'package:flutter/material.dart';

Widget appBarBackButton({BuildContext? context, VoidCallback? onPress}) =>
    IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 18,
        color: Colors.white,
      ),
      onPressed: onPress ??
          () {
            Navigator.of(context ?? I18n.context).pop();
          },
    );
