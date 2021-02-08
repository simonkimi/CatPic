import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:catpic/utils/image/cached_dio_image_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static String routeName = 'MainPage';

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
            Image(
              image: CachedDioImageProvider(
                url:
                    'https://img2.gelbooru.com/images/55/b0/55b0e398ffcdfc87ab70a0ccc66c391f.jpg',
                dio: Dio(),
                cachedKey: '123123',
              ),
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null)
                  return child;
                return CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
