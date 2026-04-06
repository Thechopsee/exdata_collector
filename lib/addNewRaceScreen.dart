import 'package:exdata_collector/Services/LocalDatabaseService/LocalDataManager.dart';
import 'package:flutter/material.dart';
import 'Models/Race.dart';
import 'package:intl/intl.dart';
import 'package:exdata_collector/l10n/app_localizations.dart';

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

  void _submitForm() async{
    if (_formKey.currentState!.validate()) {
      Race newRace = Race(
        name: _nameController.text,
        date: DateFormat('dd/MM/yyyy').parse(_dateController.text),
        rcid: 0,
        drcid: 0,
      );
      await LocalDataManager.shared.save(newRace);
      Navigator.pop(context);
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addRaceTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(l10n.name),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: l10n.name,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildLabel(l10n.dateLabel),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: l10n.dateLabel,
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
                        String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                        setState(() {
                          _dateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterDate;
                  }
                  try {
                    DateFormat('dd/MM/yyyy').parseStrict(value);
                  } catch (e) {
                    return l10n.pleaseEnterValidDate;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(l10n.submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}