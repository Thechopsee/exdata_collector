import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const String _backendUrlKey = 'backend_url';
  static SettingsManager? _instance;
  static SharedPreferences? _prefs;

  SettingsManager._();

  static Future<SettingsManager> getInstance() async {
    if (_instance == null) {
      _instance = SettingsManager._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  Future<void> setBackendUrl(String url) async {
    await _prefs?.setString(_backendUrlKey, url);
  }

  Future<String> getBackendUrl() async {
    return _prefs?.getString(_backendUrlKey) ?? 'http://127.0.0.1:5000';
  }

  Future<void> clearAllSettings() async {
    await _prefs?.clear();
  }
}
