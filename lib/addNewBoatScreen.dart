import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Services/LocalDatabaseService/LocalDataManager.dart';
import 'package:flutter/material.dart';
import 'package:exdata_collector/l10n/app_localizations.dart';

class addNewBoatScreen extends StatefulWidget {
  const addNewBoatScreen({Key? key}) : super(key: key);

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<addNewBoatScreen> {
  String? _selectedOption;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();
  final TextEditingController _explainController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    _secondsController.dispose();
    _explainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addBoat),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              l10n.category,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Radio<String>(
                  value: 'EX-500',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                      // Vyčistit extra pole když změní na EX-500
                      _secondsController.clear();
                      _explainController.clear();
                    });
                  },
                ),
                const Text('ex500'),
                Radio<String>(
                  value: 'EX-A',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                ),
                const Text('exA'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: l10n.enterBoatName,
                border: const OutlineInputBorder(),
              ),
            ),

            // Podmíněné zobrazení polí pro EX-A
            if (_selectedOption == 'EX-A') ...[
              const SizedBox(height: 20),
              Text(
                l10n.secondsInTimer,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _secondsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: l10n.enterSeconds,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.explainTimer,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _explainController,
                decoration: InputDecoration(
                  hintText: l10n.explainTimerHint,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = _textEditingController.text;

                if (name.isEmpty || _selectedOption == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(l10n.pleaseFillAllFields),
                    duration: const Duration(seconds: 2),
                  ));
                  return;
                }

                // Pokud je EX-A, ověřit, že číslo i text jsou vyplněné
                if (_selectedOption == 'EX-A') {
                  if (_secondsController.text.isEmpty ||
                      int.tryParse(_secondsController.text) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(l10n.pleaseEnterValidSeconds),
                      duration: const Duration(seconds: 2),
                    ));
                    return;
                  }
                  if (_explainController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(l10n.pleaseExplainTimer),
                      duration: const Duration(seconds: 2),
                    ));
                    return;
                  }
                }
                var boat=Boat(name:name,boatClass:_selectedOption.toString() );
                boat.timerSeconds=_secondsController.text;
                boat.timerExplanation=_explainController.text;
                LocalDataManager.shared.save(boat);

                print(
                    'Name: $name, Option: $_selectedOption, Seconds: ${_secondsController.text}, Explanation: ${_explainController.text}');

                Navigator.pop(context);
              },
              child: Text(l10n.addBoat),
            ),
          ],
        ),
      ),
    );
  }
}
