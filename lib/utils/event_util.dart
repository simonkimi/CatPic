import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  static final EventBusUtil _instance = EventBusUtil._constructor();

  EventBusUtil._constructor();

  factory EventBusUtil() {
    return _instance;
  }

  EventBus _eventBus = EventBus();

  EventBus get bus => _eventBus;

}



class EventSiteChange {

}