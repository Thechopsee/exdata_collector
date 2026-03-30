import 'package:flutter/material.dart';
import '../Models/ThemeConfig.dart';
import 'SettingsManager.dart';

class ConfigProvider with ChangeNotifier {
  ThemeConfig _themeConfig = ThemeConfig(
    primaryColor: Colors.deepPurple,
    textSizeMultiplier: 1.0,
  );

  ThemeConfig get themeConfig => _themeConfig;

  Future<void> loadSettings() async {
    final settingsManager = await SettingsManager.getInstance();
    String colorHex = await settingsManager.getPrimaryColor();
    double textSizeMultiplier = await settingsManager.getTextSizeMultiplier();

    _themeConfig = ThemeConfig(
      primaryColor: Color(int.parse(colorHex, radix: 16)),
      textSizeMultiplier: textSizeMultiplier,
    );
    notifyListeners();
  }

  Future<void> updateTheme({Color? primaryColor, double? textSizeMultiplier}) async {
    _themeConfig = _themeConfig.copyWith(
      primaryColor: primaryColor,
      textSizeMultiplier: textSizeMultiplier,
    );

    final settingsManager = await SettingsManager.getInstance();
    if (primaryColor != null) {
      await settingsManager.setPrimaryColor(primaryColor.value.toRadixString(16).toUpperCase());
    }
    if (textSizeMultiplier != null) {
      await settingsManager.setTextSizeMultiplier(textSizeMultiplier);
    }

    notifyListeners();
  }
}
