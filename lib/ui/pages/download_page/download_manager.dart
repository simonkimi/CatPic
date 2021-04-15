import 'package:catpic/i18n.dart';
import 'package:flutter/material.dart';

class DownloadManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Container(),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        I18n.of(context).download_manager,
        style: const TextStyle(fontSize: 18),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
