import 'package:flutter/material.dart';
import 'Models/Boat.dart';
import 'Services/LocalSaver.dart';
import 'addNewBoatScreen.dart';
import 'addNewScoreScreen.dart';
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

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  _loadItems() async {
    List<Boat> loadedItems = await LocalSaver.loadAllBoats();
    setState(() {


      _items = loadedItems;
    });
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
    );
  }

  void _navigateToNewBoat() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => addNewBoatScreen(),
      ),
    );
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_items[index].name.toString()),
            subtitle: Text(_items[index].boatClass.toString()),
            onTap: () {
              _navigateToNewScreen(_items[index].id);
            },
            onLongPress: () {_navigateRunList(_items[index].id);},
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'uniqueTag1',
            onPressed: () {_navigateToNewScreen(-1);},
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'uniqueTag2',
            onPressed: _navigateToNewBoat,
            tooltip: 'Navigate to New Boat',
            child: const Icon(Icons.directions_boat),
          ),
        ],
      ),
    );
  }
}

