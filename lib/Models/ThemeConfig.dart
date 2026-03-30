import 'package:flutter/material.dart';

class ThemeConfig {
  final Color primaryColor;
  final double textSizeMultiplier;

  ThemeConfig({
    required this.primaryColor,
    required this.textSizeMultiplier,
  });

  ThemeData get themeData {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      useMaterial3: true,
      textTheme: const TextTheme().apply(
        fontSizeFactor: textSizeMultiplier,
      ),
    );
  }

  // Helper to create a copy with some changed fields
  ThemeConfig copyWith({
    Color? primaryColor,
    double? textSizeMultiplier,
  }) {
    return ThemeConfig(
      primaryColor: primaryColor ?? this.primaryColor,
      textSizeMultiplier: textSizeMultiplier ?? this.textSizeMultiplier,
    );
  }
}
