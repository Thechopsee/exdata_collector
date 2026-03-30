import 'package:exdata_collector/Services/LocalDatabaseService/LocalDataManager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:exdata_collector/l10n/app_localizations.dart';

import 'Components/RunItem.dart';
import 'Helpers/UIHelper.dart';
import 'Models/Boat.dart';
import 'Models/Run.dart';
import 'Models/Race.dart';

class RaceRunList extends StatefulWidget {
  final int raceId;

  const RaceRunList({Key? key, required this.raceId}) : super(key: key);

  @override
  _RaceRunListState createState() => _RaceRunListState();
}

class _RaceRunListState extends State<RaceRunList> {
  Map<Boat, List<Run>> groupedRuns = {};
  Map<String, Color> boatColors = {};
  Race? race;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadRaceData();
  }

  Future<void> _loadRaceData() async {
    try {
      // Načtení dat závodu
      final raceData = await LocalDataManager.shared.load<Race>(Race, widget.raceId);
      
      // Načtení všech jízd pro daný závod
      final runs = await LocalDataManager.shared.loadByParam<Run>(Run, "rcid", widget.raceId.toString());
      
      Map<String, Boat> boatCache = {};
      Map<Boat, List<Run>> tempGrouped = {};
      Map<String, Color> tempColors = {};

      for (var run in runs) {
        // Načtení lodi pokud ještě není v cache
        if (!boatCache.containsKey("${run.boatID}")) {
          boatCache["${run.boatID}"] = await LocalDataManager.shared.load<Boat>(Boat, run.boatID);
          tempColors["${run.boatID}"] = UIHelper.generateRandomColor();
        }
        final boat = boatCache["${run.boatID}"]!;

        // Seskupení jízd podle lodí
        if (!tempGrouped.containsKey(boat)) {
          tempGrouped[boat] = [];
        }
        tempGrouped[boat]!.add(run);
      }

      setState(() {
        race = raceData;
        groupedRuns = tempGrouped;
        boatColors = tempColors;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      // Zde by mohlo být zobrazení chyby
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(race?.name ?? l10n.raceRunsTitle),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : groupedRuns.isEmpty
              ? Center(
                  child: Text(
                    l10n.noRunsForRace,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView(
                  children: groupedRuns.entries.map((entry) {
                    final boat = entry.key;
                    final runs = entry.value;
                    final color = boatColors["${boat.bID}"] ?? Colors.grey;

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
                              '${boat.name} • ${boat.boatClass}',
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
