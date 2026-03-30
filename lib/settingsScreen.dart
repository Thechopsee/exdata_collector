import 'package:flutter/material.dart';
import 'package:exdata_collector/Services/SettingsManager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _optionsController = TextEditingController();
  final TextEditingController _labelIntendedScoreController = TextEditingController();
  final TextEditingController _labelIntendedDirectionController = TextEditingController();
  final TextEditingController _labelGatePartController = TextEditingController();
  final TextEditingController _labelGainedScoreController = TextEditingController();
  final TextEditingController _labelHitDirectionController = TextEditingController();

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
    String title = await _settingsManager.getAppTitle();
    String color = await _settingsManager.getPrimaryColorHex();
    List<String> options = await _settingsManager.getDirectionOptions();
    String lIntScore = await _settingsManager.getLabelIntendedScore();
    String lIntDir = await _settingsManager.getLabelIntendedDirection();
    String lGate = await _settingsManager.getLabelGatePart();
    String lGainScore = await _settingsManager.getLabelGainedScore();
    String lHitDir = await _settingsManager.getLabelHitDirection();

    setState(() {
      _urlController.text = url;
      _titleController.text = title;
      _colorController.text = color;
      _optionsController.text = options.join(',');
      _labelIntendedScoreController.text = lIntScore;
      _labelIntendedDirectionController.text = lIntDir;
      _labelGatePartController.text = lGate;
      _labelGainedScoreController.text = lGainScore;
      _labelHitDirectionController.text = lHitDir;
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    _colorController.dispose();
    _optionsController.dispose();
    _labelIntendedScoreController.dispose();
    _labelIntendedDirectionController.dispose();
    _labelGatePartController.dispose();
    _labelGainedScoreController.dispose();
    _labelHitDirectionController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    await _settingsManager.setBackendUrl(_urlController.text.trim());
    await _settingsManager.setAppTitle(_titleController.text.trim());
    await _settingsManager.setPrimaryColorHex(_colorController.text.trim());
    await _settingsManager.setDirectionOptions(
      _optionsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
    );
    await _settingsManager.setLabelIntendedScore(_labelIntendedScoreController.text.trim());
    await _settingsManager.setLabelIntendedDirection(_labelIntendedDirectionController.text.trim());
    await _settingsManager.setLabelGatePart(_labelGatePartController.text.trim());
    await _settingsManager.setLabelGainedScore(_labelGainedScoreController.text.trim());
    await _settingsManager.setLabelHitDirection(_labelHitDirectionController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully. Restart app to see full changes.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Network'),
            _buildTextField('Backend URL', _urlController, 'http://127.0.0.1:5000'),
            const SizedBox(height: 20),

            _buildSectionTitle('Appearance'),
            _buildTextField('App Title', _titleController, 'EXCategory Data Saver'),
            _buildTextField('Primary Color (Hex)', _colorController, '673AB7'),
            const SizedBox(height: 20),

            _buildSectionTitle('Labels & Options'),
            _buildTextField('Direction Options (comma separated)', _optionsController, 'L,S,P'),
            _buildTextField('Label: Intended Score', _labelIntendedScoreController, 'Intended Score:'),
            _buildTextField('Label: Intended Direction', _labelIntendedDirectionController, 'Intended Direction:'),
            _buildTextField('Label: Gate Part', _labelGatePartController, 'In with part of gate:'),
            _buildTextField('Label: Gained Score', _labelGainedScoreController, 'Gained Score:'),
            _buildTextField('Label: Hit Direction', _labelHitDirectionController, 'Hit Direction:'),
            const SizedBox(height: 20),

            _buildSectionTitle('Preview Example'),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _titleController.text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _parseColor(_colorController.text),
                    ),
                  ),
                  const Divider(),
                  Text(_labelIntendedScoreController.text),
                  const SizedBox(height: 4),
                  Row(
                    children: _optionsController.text.split(',').map((e) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(label: Text(e.trim())),
                    )).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                child: const Text('Save All Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        controller: controller,
        onChanged: (val) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      if (hex.startsWith('#')) hex = hex.substring(1);
      if (hex.length == 6) hex = 'FF' + hex;
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.deepPurple;
    }
  }
}
