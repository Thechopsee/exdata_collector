import 'package:shared_preferences/shared_preferences.dart';

class LocalSaver {
  static Future<void> setBackendUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('backendUrl', url);
  }

  static Future<String> getBackendUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('backendUrl') ?? 'http://127.0.0.1:5000';
  }
}
