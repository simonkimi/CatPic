
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef CatPicPageBuilder = CatPicPage Function();

class CatPicPage extends Page<CatPicPage> {
  const CatPicPage({
    LocalKey key,
    String name,
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

class MyRouteParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    return SynchronousFuture(routeInformation.location);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}

class MyRouteDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  MyRouteDelegate({
    @required this.home,
    @required this.onGenerateRoute,
  });

  final RouteFactory onGenerateRoute;

  final CatPicPage home;
  final _stack = <CatPicPage>[];

  static MyRouteDelegate of(BuildContext context) {
    final RouterDelegate delegate = Router.of(context).routerDelegate;
    assert(delegate is MyRouteDelegate, 'Delegate type must match');
    return delegate as MyRouteDelegate;
  }

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<String> get stack => List.unmodifiable(_stack);

  void push(CatPicPage page) {
    _stack.add(page);
    notifyListeners();
  }

  void pushBuilder(CatPicPageBuilder builder) {
    _stack.add(builder());
    notifyListeners();
  }

  void remove(String routeName) {
    print('remove $routeName');
    _stack.removeWhere((element) => element.name == routeName);
    notifyListeners();
  }

  void cleanSearchPageRouter() {
    var end = -1;
    for (var i = _stack.length - 1; i >= 0; i--) {
      if (_stack[i].name?.startsWith('SearchPage') ?? false) {
        end = i;
        break;
      }
    }
    if (end != -1) {
      _stack.removeRange(0, end);
      notifyListeners();
    }
  }

  @override
  Future<void> setInitialRoutePath(String configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    _stack
      ..clear()
      ..add(home);
    return SynchronousFuture<void>(null);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_stack.isNotEmpty) {
      print('stack: ${_stack.map((e) => e.name).toList()}');
      if (_stack.last.name == route.settings.name) {
        _stack.removeWhere((e) => e.name == route.settings.name);
        notifyListeners();
      }
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
