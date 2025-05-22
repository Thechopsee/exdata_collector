import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Components/RunItem.dart';
import 'Helpers/UIHelper.dart';
import 'Models/Run.dart';
import 'Models/Race.dart';
import 'Services/LocalSaver.dart';

class RunList extends StatefulWidget {
  final List<Run> items;

  const RunList({Key? key, required this.items}) : super(key: key);

  @override
  _RunListState createState() => _RunListState();
}

class _RunListState extends State<RunList> {
  Map<Race, List<Run>> groupedRuns = {};
  Map<String, Color> raceColors = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadRaceData();
  }

  Future<void> _loadRaceData() async {
    Map<String, Race> raceCache = {};
    Map<Race, List<Run>> tempGrouped = {};
    Map<String, Color> tempColors = {};


    for (var run in widget.items) {
      if (!raceCache.containsKey("${run.rcid}")) {
        raceCache["${run.rcid}"] = await LocalSaver.loadRaceData(run.rcid);
        tempColors["${run.rcid}"] = UIHelper.generateRandomColor();
      }
      final race = raceCache["${run.rcid}"]!;

      if (!tempGrouped.containsKey(race)) {
        tempGrouped[race] = [];
      }
      tempGrouped[race]!.add(run);
    }

    setState(() {
      groupedRuns = tempGrouped;
      raceColors = tempColors;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Run List')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: groupedRuns.entries.map((entry) {
          final race = entry.key;
          final runs = entry.value;
          final raceName = race.name;
          final raceYear = DateFormat('yyyy').format(race.date);
          final color = raceColors["${race.rcid}"] ?? Colors.grey;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 12, bottom: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                      border: Border.all(color: color.withOpacity(0.8), width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$raceName • $raceYear',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: color,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    border: Border.all(color: color.withOpacity(0.8), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: runs.map((run) => RunItem(run: run)).toList(),
                  ),
                ),
              ],
            ),
          );

        }).toList(),
      ),
    );
  }
}
