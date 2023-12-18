import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static const String _keyUserId = 'user_id';
  static const String _keyLoggedIn = 'logged_in';

  static Future<void> setUserId(String userId) async {
    await _preferences.setString(_keyUserId, userId);
  }

  static String getUserId() {
    return _preferences.getString(_keyUserId) ?? '';
  }

  static Future<void> setLoggedIn(bool loggedIn) async {
    await _preferences.setBool(_keyLoggedIn, loggedIn);
  }

  static bool isLoggedIn() {
    return _preferences.getBool(_keyLoggedIn) ?? false;
  }
}
