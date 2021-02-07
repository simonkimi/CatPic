import 'package:catpic/ui/components/cached_image.dart';
import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static String routeName = "MainPage";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            CachedDioImage(
              imgUrl:
                  'https://img2.gelbooru.com/images/86/72/8672f7ebcf7797eec98c6f76e9caacf7.png',
              imageBuilder: (context, imageProvider) {
                return Image(image: imageProvider);
              },
              loadingBuilder: (context, total, received, progress) {
                print('$total, $received, $progress');
                return Container(
                  width: 300,
                  height: 200,
                  color: Colors.yellow,
                  child: Text('$total, $received, $progress'),
                );
              },
              errorBuilder: (context, err) {
                print(err);
                return Container(
                  width: 300,
                  height: 200,
                  color: Colors.red,
                  child: Text(err.toString()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
