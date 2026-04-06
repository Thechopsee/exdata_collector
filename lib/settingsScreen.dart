import 'package:exdata_collector/Helpers/SelfTheme.dart';
import 'package:flutter/material.dart';
import 'package:exdata_collector/Services/SettingsManager.dart';
import 'package:exdata_collector/l10n/app_localizations.dart';
import 'package:exdata_collector/main.dart';
import 'package:exdata_collector/Services/OnlineSaver.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _urlController = TextEditingController();
  late SettingsManager _settingsManager;
  String _selectedLocale = 'cs';
  String _selectedThemeMode = 'system';

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  void _initializeSettings() async {
    _settingsManager = await SettingsManager.getInstance();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() async {
    String url = await _settingsManager.getBackendUrl();
    String locale = await _settingsManager.getLocale();
    String themeMode = await _settingsManager.getThemeMode();
    setState(() {
      _urlController.text = url;
      _selectedLocale = locale;
      _selectedThemeMode = themeMode;
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    String url = _urlController.text.trim();
    if (url.isNotEmpty) {
      await _settingsManager.setBackendUrl(url);
      await _settingsManager.setLocale(_selectedLocale);
      await _settingsManager.setThemeMode(_selectedThemeMode);

      // Update app locale
      MyApp.of(context)?.setLocale(Locale(_selectedLocale));
      
      // Update app theme mode
      MyApp.of(context)?.setThemeMode(_selectedThemeMode);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.backendUrlSaved)),
      );
      bool isAvailable = await OnlineSaver.checkServerAvailability(context: context, overrideUrl: url);
      if (isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backend URL uložen a server je dostupný'), backgroundColor: Colors.green),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.enterValidUrl)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.backendUrl,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            Text(
              l10n.language,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedLocale,
              isExpanded: true,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLocale = newValue;
                  });
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'cs',
                  child: Text(l10n.czech),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text(l10n.english),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.themeMode,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedThemeMode,
              isExpanded: true,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedThemeMode = newValue;
                  });
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'system',
                  child: Text(l10n.system),
                ),
                DropdownMenuItem(
                  value: 'light',
                  child: Text(l10n.light),
                ),
                DropdownMenuItem(
                  value: 'dark',
                  child: Text(l10n.dark),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
