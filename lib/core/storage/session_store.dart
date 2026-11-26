import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  SessionStore._();

  static const String _tokenKey = 'auth_token';
  static SharedPreferences? _prefs;
  static String? token;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    token = _prefs!.getString(_tokenKey);
  }

  static bool get hasToken => token != null && token!.isNotEmpty;

  static Future<void> saveToken(String value) async {
    token = value;
    await _prefs?.setString(_tokenKey, value);
  }

  static Future<void> clear() async {
    token = null;
    await _prefs?.remove(_tokenKey);
  }
}