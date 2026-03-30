import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const String _backendUrlKey = 'backend_url';
  static const String _appTitleKey = 'app_title';
  static const String _primaryColorHexKey = 'primary_color_hex';
  static const String _directionOptionsKey = 'direction_options';
  static const String _labelIntendedScoreKey = 'label_intended_score';
  static const String _labelIntendedDirectionKey = 'label_intended_direction';
  static const String _labelGatePartKey = 'label_gate_part';
  static const String _labelGainedScoreKey = 'label_gained_score';
  static const String _labelHitDirectionKey = 'label_hit_direction';

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

  Future<void> setAppTitle(String title) async {
    await _prefs?.setString(_appTitleKey, title);
  }

  Future<String> getAppTitle() async {
    return _prefs?.getString(_appTitleKey) ?? 'EXCategory Data Saver';
  }

  Future<void> setPrimaryColorHex(String hex) async {
    await _prefs?.setString(_primaryColorHexKey, hex);
  }

  Future<String> getPrimaryColorHex() async {
    return _prefs?.getString(_primaryColorHexKey) ?? '673AB7'; // Colors.deepPurple hex
  }

  Future<void> setDirectionOptions(List<String> options) async {
    await _prefs?.setStringList(_directionOptionsKey, options);
  }

  Future<List<String>> getDirectionOptions() async {
    return _prefs?.getStringList(_directionOptionsKey) ?? ['L', 'S', 'P'];
  }

  Future<void> setLabelIntendedScore(String label) async {
    await _prefs?.setString(_labelIntendedScoreKey, label);
  }

  Future<String> getLabelIntendedScore() async {
    return _prefs?.getString(_labelIntendedScoreKey) ?? 'Intended Score:';
  }

  Future<void> setLabelIntendedDirection(String label) async {
    await _prefs?.setString(_labelIntendedDirectionKey, label);
  }

  Future<String> getLabelIntendedDirection() async {
    return _prefs?.getString(_labelIntendedDirectionKey) ?? 'Intended Direction:';
  }

  Future<void> setLabelGatePart(String label) async {
    await _prefs?.setString(_labelGatePartKey, label);
  }

  Future<String> getLabelGatePart() async {
    return _prefs?.getString(_labelGatePartKey) ?? 'In with part of gate:';
  }

  Future<void> setLabelGainedScore(String label) async {
    await _prefs?.setString(_labelGainedScoreKey, label);
  }

  Future<String> getLabelGainedScore() async {
    return _prefs?.getString(_labelGainedScoreKey) ?? 'Gained Score:';
  }

  Future<void> setLabelHitDirection(String label) async {
    await _prefs?.setString(_labelHitDirectionKey, label);
  }

  Future<String> getLabelHitDirection() async {
    return _prefs?.getString(_labelHitDirectionKey) ?? 'Hit Direction:';
  }

  Future<void> clearAllSettings() async {
    await _prefs?.clear();
  }
}
