import 'package:exdata_collector/Services/LocalSaver.dart';
import 'package:flutter/material.dart';
import 'Models/Race.dart';
import 'package:intl/intl.dart';

class AddNewRaceScreen extends StatefulWidget {
  @override
  _AddNewRaceScreenState createState() => _AddNewRaceScreenState();
}

class _AddNewRaceScreenState extends State<AddNewRaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Race newRace = Race(
        name: _nameController.text,
        date: DateFormat.yMd().parse(_dateController.text),
        rcid: 0,
        drcid: 0,
      );
      LocalSaver.saveRaceData(race: newRace);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Race'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date (MM/DD/YYYY)',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        String formattedDate = DateFormat.yMd().format(pickedDate);
                        setState(() {
                          _dateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  try {
                    DateFormat.yMd().parseStrict(value);
                  } catch (e) {
                    return 'Please enter a valid date';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}