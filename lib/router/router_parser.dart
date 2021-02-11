import 'package:flutter/material.dart';

import 'catpic_page.dart';

class MyRouteParser extends RouteInformationParser<AppPath> {
  @override
  Future<AppPath> parseRouteInformation(
      RouteInformation routeInformation) async {
    print('parseRouteInformation${routeInformation.location}');
    return AppPath.search();
  }

}
