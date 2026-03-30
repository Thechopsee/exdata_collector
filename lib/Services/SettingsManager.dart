import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const String _backendUrlKey = 'backend_url';
  static const String _primaryColorKey = 'primary_color';
  static const String _textSizeMultiplierKey = 'text_size_multiplier';

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

  Future<void> setPrimaryColor(String colorHex) async {
    await _prefs?.setString(_primaryColorKey, colorHex);
  }

  Future<String> getPrimaryColor() async {
    return _prefs?.getString(_primaryColorKey) ?? 'FF673AB7'; // Default DeepPurple
  }

  Future<void> setTextSizeMultiplier(double multiplier) async {
    await _prefs?.setDouble(_textSizeMultiplierKey, multiplier);
  }

  Future<double> getTextSizeMultiplier() async {
    return _prefs?.getDouble(_textSizeMultiplierKey) ?? 1.0;
  }

  Future<void> clearAllSettings() async {
    await _prefs?.clear();
  }
}
