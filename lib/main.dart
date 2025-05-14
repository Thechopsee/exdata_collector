import 'package:flutter/material.dart';
import 'Models/Boat.dart';
import 'Models/Race.dart';
import 'Services/LocalSaver.dart';
import 'Services/OnlineSaver.dart';
import 'addNewBoatScreen.dart';
import 'addNewScoreScreen.dart';
import 'addNewRaceScreen.dart';
import 'runList.dart';
import "Models/Run.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EXCategory Data Saver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'EXCategory Data Saver'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Boat> _items = [];
  List<Race> races=[];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  _loadItems() async {
    List<Boat> loadedItems = await LocalSaver.loadAllBoats();
    List<Race> loadedRaces =await LocalSaver.loadAllRaces();
    print(loadedRaces);
    setState(() {

      races=loadedRaces;
      _items = loadedItems;
    });
  }

  void _deleteData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Data'),
          content: Text('Are you sure you want to delete all data?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                LocalSaver.deleteData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToNewScreen(int from) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => addNewScoreScreen(from: from,),
      ),
    );
  }
  void  _navigateRunList(int boatID) async {
    List<Run> runlist=await LocalSaver.loadRunData(id: boatID);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RunList(items: runlist,),
      ),
    ).then((_){_loadItems();});
  }
  void  _navigateNewRace() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNewRaceScreen(),
      ),
    ).then((_){_loadItems();});
  }

  void _navigateToNewBoat() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => addNewBoatScreen(),
      ),
    ).then((_){_loadItems();});
  }
  void _Synchronize() async {
    await OnlineSaver.Synchronize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'delete') {
                _deleteData();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete Data'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_items[index].name.toString()),
                  subtitle: Text(_items[index].boatClass.toString()),
                  onTap: () {
                    _navigateToNewScreen(_items[index].bID);
                  },
                  onLongPress: () {
                    if (_items[index].dbID == 0) {
                      _navigateRunList(_items[index].bID);
                    } else {
                      _navigateRunList(_items[index].dbID);
                    }
                  },
                );
              },
            ),
          ),
          Divider(), // Optional: Adds a separator between the lists
          Expanded(
            child: ListView.builder(
              itemCount: races.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(races[index].name.toString()),
                  subtitle: Text(races[index].date.toString()),
                  onTap: () {
                    //_navigateToNewScreen(_items[index].bID);
                  },

                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'uniqueTag1',
            onPressed: () {_navigateToNewScreen(-1);},
            tooltip: 'Add New Score',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'uniqueTag2',
            onPressed: _navigateToNewBoat,
            tooltip: 'Navigate to New Boat',
            child: const Icon(Icons.directions_boat),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'uniqueTag6',
            onPressed: _navigateNewRace,
            tooltip: 'Navigate to New Race',
            child: const Icon(Icons.date_range),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'uniqueTag3',
            onPressed: _Synchronize,
            tooltip: 'synchronize',
            child: const Icon(Icons.sync),
          ),
        ],
      ),
    );
  }
}

