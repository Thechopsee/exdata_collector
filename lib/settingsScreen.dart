import 'package:flutter/material.dart';
import 'package:exdata_collector/Services/SettingsManager.dart';
import 'package:exdata_collector/Services/OnlineSaver.dart';
import 'package:provider/provider.dart';
import 'Services/ConfigProvider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  late SettingsManager _settingsManager;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  void _initializeSettings() async {
    _settingsManager = await SettingsManager.getInstance();
    _loadSettings();
  }

  void _loadSettings() async {
    String url = await _settingsManager.getBackendUrl();
    String colorHex = await _settingsManager.getPrimaryColor();
    setState(() {
      _urlController.text = url;
      _colorController.text = colorHex;
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _saveUrl() async {
    String url = _urlController.text.trim();
    if (url.isNotEmpty) {
      await _settingsManager.setBackendUrl(url);
      bool isAvailable = await OnlineSaver.checkServerAvailability(context: context, overrideUrl: url);
      if (isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backend URL uložen a server je dostupný'), backgroundColor: Colors.green),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<ConfigProvider>(
        builder: (context, config, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Backend URL:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    hintText: 'http://127.0.0.1:5000',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveUrl,
                  child: const Text('Save URL'),
                ),
                const Divider(height: 40),
                const Text(
                  'Theme Color (Hex ARGB):',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    hintText: 'FF673AB7',
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (value) {
                    try {
                      Color color = Color(int.parse(value, radix: 16));
                      config.updateTheme(primaryColor: color);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid color format')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    try {
                      Color color = Color(int.parse(_colorController.text, radix: 16));
                      config.updateTheme(primaryColor: color);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid color format')),
                      );
                    }
                  },
                  child: const Text('Update Color'),
                ),
                const Divider(height: 40),
                Text(
                  'Text Size Multiplier: ${config.themeConfig.textSizeMultiplier.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: config.themeConfig.textSizeMultiplier,
                  min: 0.5,
                  max: 2.0,
                  onChanged: (value) {
                    config.updateTheme(textSizeMultiplier: value);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
