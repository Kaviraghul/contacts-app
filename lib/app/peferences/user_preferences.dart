import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static const String _keyUserId = 'user_id';
  static const String _keyLoggedIn = 'logged_in';
  static const String _keyUserOnboarded = 'user_onboarded';

  // => user id

  static Future<void> setUserId(String userId) async {
    await _preferences.setString(_keyUserId, userId);
  }

  static String getUserId() {
    return _preferences.getString(_keyUserId) ?? '';
  }

  // => user onboarded

  static Future<void> setIsUserOnboarded(bool userOnboarded) async {
    await _preferences.setBool(_keyUserOnboarded, userOnboarded);
  }

  static bool getIsUserOnboarded() {
    return _preferences.getBool(_keyUserOnboarded) ?? false;
  }

  // => user logged in

  static Future<void> setLoggedIn(bool loggedIn) async {
    await _preferences.setBool(_keyLoggedIn, loggedIn);
  }

  static bool isLoggedIn() {
    return _preferences.getBool(_keyLoggedIn) ?? false;
  }
}
