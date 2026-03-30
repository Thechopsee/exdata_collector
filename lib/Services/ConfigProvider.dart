import 'package:flutter/material.dart';
import 'SettingsManager.dart';

class ConfigProvider {
  static final ConfigProvider _instance = ConfigProvider._internal();
  factory ConfigProvider() => _instance;
  ConfigProvider._internal();

  static ConfigProvider get instance => _instance;

  String appTitle = 'EXCategory Data Saver';
  Color primaryColor = Colors.deepPurple;

  String labelIntendedScore = 'Intended Score:';
  String labelIntendedDirection = 'Intended Direction:';
  String labelGatePart = 'In with part of gate:';
  String labelGainedScore = 'Gained Score:';
  String labelHitDirection = 'Hit Direction:';

  List<String> directionOptions = ['L', 'S', 'P'];

  Future<void> initialize() async {
    final settings = await SettingsManager.getInstance();

    appTitle = await settings.getAppTitle();
    primaryColor = _parseColor(await settings.getPrimaryColorHex());

    labelIntendedScore = await settings.getLabelIntendedScore();
    labelIntendedDirection = await settings.getLabelIntendedDirection();
    labelGatePart = await settings.getLabelGatePart();
    labelGainedScore = await settings.getLabelGainedScore();
    labelHitDirection = await settings.getLabelHitDirection();

    directionOptions = await settings.getDirectionOptions();
  }

  Color _parseColor(String hex) {
    try {
      if (hex.startsWith('#')) {
        hex = hex.substring(1);
      }
      if (hex.length == 6) {
        hex = 'FF' + hex;
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.deepPurple;
    }
  }
}
