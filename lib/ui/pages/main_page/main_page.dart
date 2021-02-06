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
                  'https://img2.gelbooru.com/images/f3/4b/f34b89bfc20170f52191caffbb184242.jpg',
              cachedKey: "f34b89bfc20170f52191caffbb184242",
              imageBuilder: (context, imageProvider) {
                return Image(image: imageProvider);
              },
              loadingBuilder: (context, total, received, progress) {
                print('$total, $received, $progress');
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.yellow,
                );
              },
              errorBuilder: (context, err) {
                print(err);
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
