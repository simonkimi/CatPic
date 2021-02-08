import 'package:flutter/material.dart';

class CatPicPage extends Page<CatPicPage> {
  const CatPicPage({
    @required LocalKey key,
    @required String name,
    @required this.builder,
  }) : super(key: key, name: name);

  final WidgetBuilder builder;

  @override
  Route<CatPicPage> createRoute(BuildContext context) {
    return MaterialPageRoute<CatPicPage>(
      settings: this,
      builder: builder,
    );
  }

  @override
  String toString() => name;
}
