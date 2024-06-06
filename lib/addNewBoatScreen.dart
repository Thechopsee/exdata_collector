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

  @override
  void dispose() {
    _textEditingController.dispose();
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
            const SizedBox(height: 20),
            const Text(
              'Choose an option:',
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
            ElevatedButton(
              onPressed: () {
                String name = _textEditingController.text;
                if (name.isNotEmpty && _selectedOption != null) {
                  LocalSaver.saveBoatData(text:name, selectedOption: _selectedOption.toString());
                  print('Name: $name, Option: $_selectedOption');
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill all fields.'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              child: Text('Add Boat'),
            ),
          ],
        ),
      ),
    );
  }
}
