import 'package:flutter/material.dart';

typedef CatPicPageBuilder = CatPicPage Function();

class CatPicPage extends Page<CatPicPage> {
  const CatPicPage({
    LocalKey key,
    String name,
    this.body,
  }) : super(key: key, name: name);

  final Widget body;

  @override
  Route<CatPicPage> createRoute(BuildContext context) {
    return MaterialPageRoute<CatPicPage>(
      settings: this,
      builder: (context) => body,
    );
  }

  @override
  String toString() => name;
}

class AppPath {
  AppPath.search() : _path = '/search';

  AppPath.hostManager() : _path = '/hostManager';

  AppPath.imageView() : _path = '/imageView';

  AppPath.websiteAdd() : _path = '/websiteAdd';

  AppPath.websiteManager() : _path = '/websiteManager';

  final String _path;

  String get path => _path;
}
