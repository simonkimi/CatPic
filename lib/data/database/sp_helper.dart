import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  static final SPHelper _spHelper = SPHelper._internal();

  factory SPHelper() => _spHelper;

  SPHelper._internal();

  SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get pref => _prefs;
}
