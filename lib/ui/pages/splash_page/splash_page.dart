import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

import '../../../main.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  Future<void> loading() async {
    await settingStore.init();
    await mainStore.init();
    downloadStore.startDownload();
  }

  Widget buildHello(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: (SpUtil.getInt('theme') ?? 1) < 0
              ? const Color(0xFF303030)
              : Colors.white,
          child: const Center(
            child: Text(
              'CatPic',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: FutureBuilder<void>(
        future: loading(),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
            child: snapshot.connectionState == ConnectionState.done
                ? CatPicApp()
                : buildHello(context),
          );
        },
      ),
    );
  }
}
