import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/tag_entity.dart';
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
    final insertController = TextEditingController();
    final queryController = TextEditingController();

    final tagDao = DatabaseHelper().tagDao;

    return Scaffold(
      drawer: MainDrawer(),
      body: SafeArea(
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: insertController,
              ),
              OutlineButton(
                child: const Text('Insert'),
                onPressed: () async {
                  await tagDao.addTag(TagEntity(
                      website: -1,
                      tag: insertController.text
                  ));
                },
              ),
              TextFormField(
                controller: queryController,
              ),
              OutlineButton(
                child: const Text('Query'),
                onPressed: () async {
                  final list = await tagDao.getStart(-1, queryController.text);
                  print(list.map((e) => e.tag));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
