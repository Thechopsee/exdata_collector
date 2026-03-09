import 'dart:convert';
import 'dart:io';
import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Services/LocalDatabaseService/LocalDataManager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  String? _base64Image;

  @override
  void dispose() {
    _textEditingController.dispose();
    _secondsController.dispose();
    _explainController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );

    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Boat'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _base64Image != null
                      ? MemoryImage(base64Decode(_base64Image!))
                      : null,
                  child: _base64Image == null
                      ? const Icon(Icons.add_a_photo, size: 40)
                      : null,
                ),
              ),
            ),
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
                var boat = Boat(name: name, boatClass: _selectedOption.toString());
                boat.timerSeconds = _secondsController.text;
                boat.timerExplanation = _explainController.text;
                boat.image = _base64Image;
                LocalDataManager.shared.save(boat);

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
