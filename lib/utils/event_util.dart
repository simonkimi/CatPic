import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  factory EventBusUtil() => _instance;

  EventBusUtil._constructor();

  static final EventBusUtil _instance = EventBusUtil._constructor();

  final EventBus _eventBus = EventBus();

  EventBus get bus => _eventBus;
}

class EventSiteListChange {}

class EventSiteChange {}