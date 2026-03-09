import 'package:exdata_collector/Models/Run.dart';
import 'package:exdata_collector/Services/LocalDatabaseService/LocalDataManager.dart';
import 'package:flutter/material.dart';
import 'Models/Boat.dart';
import 'Models/Race.dart';

class addNewScoreScreen extends StatefulWidget {
  const addNewScoreScreen({Key? key, required this.from}) : super(key: key);
  final int from;

  @override
  _addNewScoreScreenState createState() => _addNewScoreScreenState(from);
}

class _addNewScoreScreenState extends State<addNewScoreScreen> {
  void _showNoRacesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("No Race "),
        content: const Text("Unfortunately, there are no races available"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  Future<void> showNoBoatDialog() async
  {
    await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Warning'),
      content: Text('Zatím nejsou vyplněny žádné lodě.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    ),
    );
  }
  void loadOptions ()async
  {
    boatOptions=await LocalDataManager.shared.loadAll<Boat>(Boat);
    races=await LocalDataManager.shared.loadAll<Race>(Race);
    for(int i=0;i<races.length;i++)
      {
        _racesC.add("${races[i].rcid} ${races[i].name} ${races[i].date.year}");
      }
    for(int i=0;i<boatOptions.length;i++)
      {
        _boatOptionsC.add(boatOptions[i].toColumnString());
      }
    if (_boatOptionsC.length < 1) {
        await showNoBoatDialog();
      return;
    }

    _boatSelection = _boatOptionsC[0];
    if(_racesC.length==0)
      {
        Future.microtask(() => _showNoRacesDialog());
      }
    _raceSelection=_racesC[0];
  }
  int boatID = 0;
  String? _selectedOption;
  String? _gatePartSelected;
  TextEditingController _textEditingController = TextEditingController();
  String? _secondSelectedOption;
  TextEditingController _secondTextEditingController = TextEditingController();
  String? _boatSelection;
  String? _raceSelection;
  List<String> _boatOptionsC=[];
  List<String> options = ['L', 'S', 'P'];
  List<Boat> boatOptions=[];
  List<Race> races=[];
  List<String> _racesC=[];
  bool showCombo=false;

  _addNewScoreScreenState(int from) {
    if(from==-1)
      {
        showCombo=true;
      }
    boatID = from;
    loadOptions();
    if(_boatOptionsC.isNotEmpty) {
      _boatSelection = _boatOptionsC[0];
    }
  }
  @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _secondTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Record'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intended Score
              _buildLabel('Intended Score:'),
              TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Score',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Intended Direction
              _buildLabel('Intended Direction:'),
              _buildRadioGroup(_selectedOption, (val) {
                setState(() => _selectedOption = val);
              }),

              const SizedBox(height: 20),

              // Gate Part
              _buildLabel('In with part of gate:'),
              _buildRadioGroup(_gatePartSelected, (val) {
                setState(() => _gatePartSelected = val);
              }),

              const SizedBox(height: 20),

              // Gained Score
              _buildLabel('Gained Score:'),
              TextField(
                controller: _secondTextEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Score',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // Hit Direction
              _buildLabel('Hit Direction:'),
              _buildRadioGroup(_secondSelectedOption, (val) {
                setState(() => _secondSelectedOption = val);
              }),

              const SizedBox(height: 20),

              if (showCombo) ...[
                _buildLabel('Boat:'),
                _buildDropdown(_boatSelection, _boatOptionsC, (val) {
                  setState(() => _boatSelection = val);
                }),
                const SizedBox(height: 20),
              ],

              _buildLabel('Race:'),
              _buildDropdown(_raceSelection, _racesC, (val) {
                setState(() => _raceSelection = val);
              }),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  void _handleSubmit() {
    if (showCombo) {
      boatID = int.parse(_boatSelection!.split(" ")[0]);
    }

    int raceID = int.parse(_raceSelection!.split(" ")[0]);

    var run = Run()
      ..boatID = boatID
      ..rcid = raceID
      ..scopeTo = int.tryParse(_textEditingController.text) ?? 0
      ..hit = int.tryParse(_secondTextEditingController.text) ?? 0
      ..directionTo = _selectedOption ?? ''
      ..directionHit = _secondSelectedOption ?? ''
      ..intendedPartOfGate = _gatePartSelected ?? '';

    LocalDataManager.shared.save(run);
    Navigator.pop(context);
  }


  Widget _buildRadioGroup(String? selectedValue, ValueChanged<String?> onChanged) {
    return Row(
      children: ['L', 'S', 'P'].map((option) {
        return Row(
          children: [
            Radio<String>(
              value: option,
              groupValue: selectedValue,
              onChanged: onChanged,
            ),
            Text(option),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDropdown(String? value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      isExpanded: true,
      value: value,
      onChanged: onChanged,
      items: items.map((val) {
        return DropdownMenuItem(
          value: val,
          child: Text(val),
        );
      }).toList(),
    );
  }


}
