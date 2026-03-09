import 'dart:convert';
import 'package:exdata_collector/Services/LocalDatabaseService/LocalDataManager.dart';
import 'package:http/http.dart' as http;
import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Models/Run.dart';
import 'package:exdata_collector/Models/Race.dart';

class OnlineSaver {
  static const String baseUrl = 'http://127.0.0.1:5000';

  static Future<void> SynchronizeRaces() async {
    List<Race> races = await LocalDataManager.shared.loadAll<Race>(Race);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'raceList': races.map((race) => race.toJson()).toList()});

    final response = await http.post(Uri.parse(baseUrl + "/races/sync"), headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Races synchronized successfully');
      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty) {
        List<Race> updatedRaces = responseData.map((data) => Race.fromJson(data)).toList();
        print('Races synchronized with updates: $updatedRaces');

        for (var updatedRace in updatedRaces) {
          updatedRace.drcid = updatedRace.rcid;
          // Find local rcid by matching name and date
          for (var localRace in races) {
            if (localRace.name == updatedRace.name &&
                localRace.date.toIso8601String() == updatedRace.date.toIso8601String()) {
              updatedRace.rcid = localRace.rcid;
              break;
            }
          }
          await LocalDataManager.shared.save(updatedRace);
        }
      }
    }
  }

  static Future<void> Synchronize() async {
    List<Boat> boats = await LocalDataManager.shared.loadAll<Boat>(Boat);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'boatList': boats.map((boat) => boat.toJson()).toList()});

    final response = await http.post(Uri.parse(baseUrl + "/boats/sync"), headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Boats synchronized successfully');
      final List<dynamic> responseData = jsonDecode(response.body);
      List<Boat> finalBoats = boats;
      if (responseData.isNotEmpty) {
        List<Boat> updatedBoatsFromServer = responseData.map((data) => Boat.fromJson(data)).toList();
        print('Boats synchronized with updates: $updatedBoatsFromServer');

        for (var updatedBoat in updatedBoatsFromServer) {
          // Find local bID by matching name and boatClass
          for (var localBoat in boats) {
            if (localBoat.name == updatedBoat.name && localBoat.boatClass == updatedBoat.boatClass) {
              updatedBoat.bID = localBoat.bID;
              break;
            }
          }
          await LocalDataManager.shared.save(updatedBoat);
        }
        finalBoats = await LocalDataManager.shared.loadAll<Boat>(Boat);
      }
      await SynchronizeRaces();
      await SynchronizeRun(finalBoats);
    } else {
      print('Failed to synchronize boats: ${response.statusCode}');
    }
  }

  static Future<void> SynchronizeRun(List<Boat> currentBoats) async {
    List<Run> runs = await LocalDataManager.shared.loadAll<Run>(Run);
    List<Race> races = await LocalDataManager.shared.loadAll<Race>(Race);
    List<Run> filteredRuns = [];

    for (var run in runs) {
      bool boatFound = false;
      for (var boat in currentBoats) {
        if (run.boatID == boat.bID) {
          run.boatID = boat.dbID;
          boatFound = true;
          break;
        }
      }

      bool raceFound = false;
      for (var race in races) {
        if (run.rcid == race.rcid) {
          run.rcid = race.drcid;
          raceFound = true;
          break;
        }
      }

      if (boatFound && raceFound) {
        filteredRuns.add(run);
      }
    }

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'runList': filteredRuns.map((run) => run.toJson()).toList()});
    final response = await http.post(Uri.parse(baseUrl + "/runs/sync"), headers: headers, body: body);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<Run> updatedRuns = responseData.map((data) => Run.fromJson(data)).toList();
      print('Runs synchronized with updates: $updatedRuns');

      for (var updatedRun in updatedRuns) {
        // Re-loading original runs to get local IDs
        List<Run> localRuns = await LocalDataManager.shared.loadAll<Run>(Run);
        for(var localRun in localRuns) {
           // We can match by dateTime and boatID (original local)
           if (localRun.dateTime.toIso8601String() == updatedRun.dateTime.toIso8601String()) {
             updatedRun.rid = localRun.rid;
             updatedRun.boatID = localRun.boatID;
             updatedRun.rcid = localRun.rcid;
             break;
           }
        }

        await LocalDataManager.shared.save(updatedRun);
      }
    }
  }

  static Future<void> saveRunData({required Run run}) async {
    final url = Uri.parse('$baseUrl/runs');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(run.toJson()),
    );

    if (response.statusCode == 201) {
      print('Run data saved successfully');
    } else {
      print('Failed to save run data: ${response.statusCode}');
    }
  }

  static Future<List<Run>> loadAllRunData() async {
    final url = Uri.parse('$baseUrl/runs');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((run) => Run.fromJson(run)).toList();
    } else {
      print('Failed to load run data: ${response.statusCode}');
      return [];
    }
  }

  static Future<void> saveBoatData({required Boat boat}) async {
    final url = Uri.parse('$baseUrl/boats');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(boat.toJson()),
    );

    if (response.statusCode == 201) {
      print('Boat data saved successfully');
    } else {
      print('Failed to save boat data: ${response.statusCode}');
    }
  }

  static Future<List<Boat>> loadAllBoats() async {
    final url = Uri.parse('$baseUrl/boats');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((boat) => Boat.fromJson(boat)).toList();
    } else {
      print('Failed to load boats data: ${response.statusCode}');
      return [];
    }
  }

  static Future<void> saveRaceData({required Race race}) async {
    final url = Uri.parse('$baseUrl/races');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(race.toJson()),
    );

    if (response.statusCode == 201) {
      print('Race data saved successfully');
    } else {
      print('Failed to save race data: ${response.statusCode}');
    }
  }

  static Future<List<Race>> loadAllRaces() async {
    final url = Uri.parse('$baseUrl/races');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((race) => Race.fromJson(race)).toList();
    } else {
      print('Failed to load races data: ${response.statusCode}');
      return [];
    }
  }
}
