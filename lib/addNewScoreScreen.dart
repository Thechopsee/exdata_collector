import 'package:flutter/material.dart';
import 'Services/LocalSaver.dart';
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
  void loadOptions ()async
  {
    boatOptions=await LocalSaver.loadAllBoats();
    races=await LocalSaver.loadAllRaces();
    for(int i=0;i<races.length;i++)
      {
        _racesC.add("${races[i].rcid} ${races[i].name} ${races[i].date.year}");
      }
    for(int i=0;i<boatOptions.length;i++)
      {
        _boatOptionsC.add(boatOptions[i].toColumnString());
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
        title: const Text('Add new Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Score:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Score',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Intended Direction:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'L',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                ),
                const Text('L'),
                Radio<String>(
                  value: 'S',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                ),
                const Text('S'),
                Radio<String>(
                  value: 'P',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                ),
                const Text('P'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Score:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _secondTextEditingController,
              decoration: const InputDecoration(
                hintText: 'Score:',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hit Direction:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'L',
                  groupValue: _secondSelectedOption,
                  onChanged: (value) {
                    setState(() {
                      _secondSelectedOption = value;
                    });
                  },
                ),
                const Text('L'),
                Radio<String>(
                  value: 'S',
                  groupValue: _secondSelectedOption,
                  onChanged: (value) {
                    setState(() {
                      _secondSelectedOption = value;
                    });
                  },
                ),
                const Text('S'),
                Radio<String>(
                  value: 'P',
                  groupValue: _secondSelectedOption,
                  onChanged: (value) {
                    setState(() {
                      _secondSelectedOption = value;
                    });
                  },
                ),
                const Text('P'),
              ],
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: showCombo,
              child:
            const Text(
              'Boat:',
              style: TextStyle(fontSize: 18),
            ),
            ),
            Visibility(
              visible: showCombo,
              child:
            DropdownButton<String>(

              value: _boatSelection,
              onChanged: (String? newValue) {
                setState(() {
                  _boatSelection = newValue;
                });
              },
              items:  _boatOptionsC.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ),
            Visibility(
              visible: showCombo,
              child:
              const Text(
                'Race:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Visibility(
              visible: true,
              child:
              DropdownButton<String>(

                value: _raceSelection,
                onChanged: (String? newValue) {
                  setState(() {
                    _raceSelection = newValue;
                  });
                },
                items:  _racesC.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if(showCombo) {
                    boatID = int.parse(_boatSelection.toString().split(" ")[0]);
                  }
                  int raceid = int.parse(_boatSelection.toString().split(" ")[0]);
                  print(boatID);
                  LocalSaver.saveRunData(
                      boatID: boatID,
                      scope: int.parse(_textEditingController.text.toString()),
                      hit: int.parse(_secondTextEditingController.text.toString()),
                      scopeToo: _selectedOption.toString(),
                      directionTOO: _secondSelectedOption.toString(),
                      rcid:raceid);
                  Navigator.pop(context);
                },
                child: const Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
