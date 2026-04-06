import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const String _backendUrlKey = 'backend_url';
  static const String _localeKey = 'locale';
  static const String _themeModeKey = 'theme_mode';
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

  Future<void> setLocale(String languageCode) async {
    await _prefs?.setString(_localeKey, languageCode);
  }

  Future<String> getLocale() async {
    return _prefs?.getString(_localeKey) ?? 'cs';
  }

  Future<void> setThemeMode(String themeMode) async {
    await _prefs?.setString(_themeModeKey, themeMode);
  }

  Future<String> getThemeMode() async {
    return _prefs?.getString(_themeModeKey) ?? 'system';
  }

  Future<void> clearAllSettings() async {
    await _prefs?.clear();
  }
}
