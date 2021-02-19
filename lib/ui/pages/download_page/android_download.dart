import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/bridge/android_bridge.dart';
import 'package:catpic/generated/l10n.dart';
import 'package:catpic/ui/store/setting/setting_store.dart';
import 'package:flutter/material.dart';

class AndroidDownloadPage extends StatefulWidget {
  @override
  _AndroidDownloadPageState createState() => _AndroidDownloadPageState();
}

mixin _AndroidDownloadPageMixin<T extends StatefulWidget> on State<T> {
  Future<void> getSafPath(BuildContext context) async {
    final uri = await getSAFUri();
    if (uri.isEmpty) {
      BotToast.showText(text: '获取授权目录失败');
    } else {
      settingStore.setDownloadModel(DownloadMode.AndroidSAF);
      settingStore.setDownloadUri(uri);
    }
    Navigator.of(context).pop();
  }
}

class _AndroidDownloadPageState extends State<AndroidDownloadPage>
    with _AndroidDownloadPageMixin {
  int currentMode = DownloadMode.AndroidSAF;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).download),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildModeSelect(),
            Expanded(child: buildDesc()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (currentMode == DownloadMode.AndroidSAF) {
            getSafPath(context);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget buildDesc() {
    if (currentMode == DownloadMode.AndroidSAF) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: const [
            Text('以SAF模式保存图片, 您必须选择一个目录授权CatPic访问\n'
                '注意: 此模式可能存在兼容性问题(无法选择等, 常见于各种非原生系统), 请使用传统模式\n'
                '但无论如何, 此模式为最推荐模式'),
            SizedBox(height: 20),
            Text('步骤1: 点击右上角显示内部储存设备(部分设备不需要)'),
            Image(image: AssetImage('assets/imgs/step1-zh-CN.png')),
            SizedBox(height: 20),
            Text('步骤2: 在侧栏中选择设备(部分设备不需要)'),
            Image(image: AssetImage('assets/imgs/step2-zh-CN.png')),
            SizedBox(height: 20),
            Text('步骤3: 选择一个您喜欢的路径, 或者新建一个文件夹'),
            Image(image: AssetImage('assets/imgs/step3-zh-CN.png')),
            SizedBox(height: 20),
            Text('步骤4: 点击确认授权访问此文件夹'),
            Image(image: AssetImage('assets/imgs/step4-zh-CN.png')),
            SizedBox(height: 100)
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: const [
            Text('以传统方式保存图片, 您必须授予读写储存空间权限, 并选择一个目录作为下载目录\n'
                '注意: 此模式在大多数Android 10上已被禁用, 从Android 10开始, 除非遇到兼容性问题, 请不要使用此方式')
          ],
        ),
      );
    }
  }

  Widget buildModeSelect() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        FlatButton(
          onPressed: () {
            setState(() {
              currentMode = DownloadMode.AndroidSAF;
            });
          },
          child: const Text('SAF'),
          color: currentMode == DownloadMode.AndroidSAF
              ? Theme.of(context).primaryColor
              : null,
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              currentMode = DownloadMode.AndroidTradition;
            });
          },
          child: const Text('传统模式'),
          color: currentMode == DownloadMode.AndroidTradition
              ? Theme.of(context).primaryColor
              : null,
        ),
      ],
    );
  }
}
