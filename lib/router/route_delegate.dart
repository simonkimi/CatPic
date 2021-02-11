import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'catpic_page.dart';

class MyRouteDelegate extends RouterDelegate<AppPath>
    with PopNavigatorRouterDelegateMixin<AppPath>, ChangeNotifier {
  MyRouteDelegate({
    @required this.home,
    @required this.onGenerateRoute,
  });

  final RouteFactory onGenerateRoute;

  final CatPicPage home;
  final _stack = <CatPicPage>[];

  GlobalKey<NavigatorState> _navigatorKey;

  CatPicPage _currentPage;

  static MyRouteDelegate of(BuildContext context) {
    final RouterDelegate delegate = Router.of(context).routerDelegate;
    assert(delegate is MyRouteDelegate, 'Delegate type must match');
    return delegate as MyRouteDelegate;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey =>
      _navigatorKey ??= GlobalKey<NavigatorState>();

  List<String> get stack => List.unmodifiable(_stack);

  void push(CatPicPage page) {
    _currentPage = page;
    _stack.add(page);
    notifyListeners();
  }


  void pushBuilder(CatPicPageBuilder builder) {
    _stack.add(builder());
    notifyListeners();
  }


  void cleanSearchPageRouter() {
    print('路由栈${_stack.map((e) => e.name).toList()}');
    var end = -1;
    for (var i = _stack.length - 1; i >= 0; i--) {
      if (_stack[i].name?.startsWith('SearchPage') ?? false) {
        end = i;
        break;
      }
    }
    if (end != -1) {
      _stack.removeRange(0, end);
      print('$end 改变后路由栈${_stack.map((e) => e.name).toList()}');
      notifyListeners();
    }
  }

  @override
  Future<void> setInitialRoutePath(AppPath configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(AppPath configuration) {
    _stack
      ..clear()
      ..add(home);
    _currentPage = home;
    return SynchronousFuture<void>(null);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    print('_onPopPage $result');
    if (_stack.isNotEmpty) {
      _stack.removeLast();
      _currentPage = _stack.last;
      notifyListeners();
    }
    return route.didPop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: List.of(_stack),
      onGenerateRoute: onGenerateRoute,
    );
  }
}
