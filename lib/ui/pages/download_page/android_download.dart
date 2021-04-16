import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/bridge/android_bridge.dart';
import 'package:catpic/i18n.dart';
import 'package:flutter/material.dart';
import 'package:catpic/main.dart';

class AndroidDownloadPage extends StatelessWidget {
  Future<void> getSafPath(BuildContext context) async {
    final uri = await getSAFUri();
    if (uri.isEmpty) {
      BotToast.showText(text: '获取授权目录失败');
    } else {
      settingStore.setDownloadUri(uri);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          I18n.of(context).download,
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
      ),
      body: SafeArea(
        child: buildDesc(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getSafPath(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget buildDesc(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: [
          Text(I18n.of(context).saf_desc1),
          const SizedBox(height: 20),
          Text(I18n.of(context).saf_desc2),
          const Image(image: AssetImage('assets/imgs/step1-zh-CN.png')),
          const SizedBox(height: 20),
          Text(I18n.of(context).saf_desc3),
          const Image(image: AssetImage('assets/imgs/step2-zh-CN.png')),
          const SizedBox(height: 20),
          Text(I18n.of(context).saf_desc4),
          const Image(image: AssetImage('assets/imgs/step3-zh-CN.png')),
          const SizedBox(height: 20),
          Text(I18n.of(context).saf_desc5),
          const Image(image: AssetImage('assets/imgs/step4-zh-CN.png')),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}
