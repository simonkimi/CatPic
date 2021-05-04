import 'package:catpic/i18n.dart';
import 'package:flutter/material.dart';

Widget appBarBackButton() => IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 18,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(I18n.context).pop();
      },
    );
