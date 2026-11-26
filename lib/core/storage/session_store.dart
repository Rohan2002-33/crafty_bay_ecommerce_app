import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  SessionStore._();

  static const String _tokenKey = 'auth_token';
  static const String _cartKey = 'local_cart_items_v2';
  static const String _wishlistKey = 'local_wishlist_items_v2';
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

  static String? getSavedCart() => _prefs?.getString(_cartKey);

  static Future<void> saveCart(String jsonStr) async {
    await _prefs?.setString(_cartKey, jsonStr);
  }

  static String? getSavedWishlist() => _prefs?.getString(_wishlistKey);

  static Future<void> saveWishlist(String jsonStr) async {
    await _prefs?.setString(_wishlistKey, jsonStr);
  }

  static Future<void> clear() async {
    token = null;
    await _prefs?.remove(_tokenKey);
    await _prefs?.remove(_cartKey);
    await _prefs?.remove(_wishlistKey);
  }
}