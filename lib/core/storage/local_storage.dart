import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Small wrapper around SharedPreferences so the rest of the app
/// does not depend on the package directly.
class LocalStorage {
  final SharedPreferences prefs;

  LocalStorage(this.prefs);

  static Future<LocalStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorage(prefs);
  }

  bool getBool(String key, {bool fallback = false}) => prefs.getBool(key) ?? fallback;

  Future<void> setBool(String key, bool value) => prefs.setBool(key, value);

  String? getString(String key) => prefs.getString(key);

  Future<void> setString(String key, String value) => prefs.setString(key, value);

  List<String> getStringList(String key) => prefs.getStringList(key) ?? [];

  Future<void> setStringList(String key, List<String> value) => prefs.setStringList(key, value);

  bool has(String key) => prefs.containsKey(key);

  Map<String, dynamic>? getJson(String key) {
    final text = prefs.getString(key);
    if (text == null) return null;
    return jsonDecode(text) as Map<String, dynamic>;
  }

  Future<void> setJson(String key, Map<String, dynamic> value) {
    return prefs.setString(key, jsonEncode(value));
  }

  List<Map<String, dynamic>>? getJsonList(String key) {
    final text = prefs.getString(key);
    if (text == null) return null;
    final list = jsonDecode(text) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> setJsonList(String key, List<Map<String, dynamic>> value) {
    return prefs.setString(key, jsonEncode(value));
  }

  Future<void> remove(String key) => prefs.remove(key);
}
