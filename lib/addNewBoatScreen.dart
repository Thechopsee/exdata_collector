import 'package:exdata_collector/Services/LocalSaver.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Boat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Category:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            const Text(
              'Name:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Enter boat name',
                border: OutlineInputBorder(),
              ),
            ),

            // Podmíněné zobrazení polí pro EX-A
            if (_selectedOption == 'EX-A') ...[
              const SizedBox(height: 20),
              const Text(
                'Seconds in timer:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _secondsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter seconds',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Explain setting a timer:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _explainController,
                decoration: const InputDecoration(
                  hintText: 'Explain timer',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = _textEditingController.text;

                if (name.isEmpty || _selectedOption == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill all fields.'),
                    duration: Duration(seconds: 2),
                  ));
                  return;
                }

                // Pokud je EX-A, ověřit, že číslo i text jsou vyplněné
                if (_selectedOption == 'EX-A') {
                  if (_secondsController.text.isEmpty ||
                      int.tryParse(_secondsController.text) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter a valid number of seconds.'),
                      duration: Duration(seconds: 2),
                    ));
                    return;
                  }
                  if (_explainController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please explain the timer setting.'),
                      duration: Duration(seconds: 2),
                    ));
                    return;
                  }
                }

                // Uložit data včetně extra polí pro EX-A
                LocalSaver.saveBoatData(
                  text: name,
                  selectedOption: _selectedOption.toString(),
                  seconds: _secondsController.text,
                  explanation: _explainController.text,
                );

                print(
                    'Name: $name, Option: $_selectedOption, Seconds: ${_secondsController.text}, Explanation: ${_explainController.text}');

                Navigator.pop(context);
              },
              child: const Text('Add Boat'),
            ),
          ],
        ),
      ),
    );
  }
}
