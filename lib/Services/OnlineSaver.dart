import 'dart:convert';
import 'package:exdata_collector/Services/LocalDatabaseService/LocalDataManager.dart';
import 'package:exdata_collector/Services/SettingsManager.dart';
import 'package:http/http.dart' as http;
import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Models/Run.dart';
import 'package:exdata_collector/Models/Race.dart';

class OnlineSaver {
  static Future<void> SynchronizeRaces() async {
    List<Race> races = await LocalDataManager.shared.loadAll<Race>(Race);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'raceList': races.map((race) => race.toJson()).toList()});
    String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
    final response = await http.post(Uri.parse(baseUrl + "/races/sync"), headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Races synchronized successfully');
      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty) {
        List<Race> serverRaces = responseData.map((data) => Race.fromJson(data)).toList();
        print('Races synchronized with updates: $serverRaces');

        for (var serverRace in serverRaces) {
          Race? localMatch;
          for (var localRace in races) {
            if ((localRace.drcid != 0 && localRace.drcid == serverRace.drcid) ||
                (localRace.name == serverRace.name &&
                    localRace.date.toIso8601String() == serverRace.date.toIso8601String())) {
              localMatch = localRace;
              break;
            }
          }

          if (localMatch != null) {
            serverRace.rcid = localMatch.rcid;
          } else {
            serverRace.rcid = 0; // New race from server
          }
          await LocalDataManager.shared.save(serverRace);
        }
      }
    }
  }

  static Future<void> Synchronize() async {
    String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
    List<Boat> boats = await LocalDataManager.shared.loadAll<Boat>(Boat);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'boatList': boats.map((boat) => boat.toJson()).toList()});

    final response = await http.post(Uri.parse(baseUrl + "/boats/sync"), headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Boats synchronized successfully');
      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty) {
        List<Boat> serverBoats = responseData.map((data) => Boat.fromJson(data)).toList();
        print('Boats synchronized with updates: $serverBoats');

        for (var serverBoat in serverBoats) {
          Boat? localMatch;
          for (var localBoat in boats) {
            if ((localBoat.dbID != 0 && localBoat.dbID == serverBoat.dbID) ||
                (localBoat.name == serverBoat.name && localBoat.boatClass == serverBoat.boatClass)) {
              localMatch = localBoat;
              break;
            }
          }

          if (localMatch != null) {
            serverBoat.bID = localMatch.bID;
          } else {
            serverBoat.bID = 0; // New boat from server
          }
          await LocalDataManager.shared.save(serverBoat);
        }
      }
      List<Boat> finalBoats = await LocalDataManager.shared.loadAll<Boat>(Boat);
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
    String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
    final response = await http.post(Uri.parse(baseUrl + "/runs/sync"), headers: headers, body: body);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<Run> serverRuns = responseData.map((data) => Run.fromJson(data)).toList();
      print('Runs synchronized with updates: $serverRuns');

      for (var serverRun in serverRuns) {
        // Map server boatID and rcid to local bID and rcid
        int localBoatID = 0;
        for (var boat in currentBoats) {
          if (boat.dbID == serverRun.boatID) {
            localBoatID = boat.bID;
            break;
          }
        }

        int localRaceID = 0;
        for (var race in races) {
          if (race.drcid == serverRun.rcid) {
            localRaceID = race.rcid;
            break;
          }
        }

        // Only save if we have valid local mappings
        if (localBoatID != 0 && localRaceID != 0) {
          serverRun.boatID = localBoatID;
          serverRun.rcid = localRaceID;

          Run? localMatch;
          for (var localRun in runs) {
            if ((localRun.drid != 0 && localRun.drid == serverRun.drid) ||
                (localRun.dateTime.toIso8601String() == serverRun.dateTime.toIso8601String() &&
                    localRun.boatID == serverRun.boatID &&
                    localRun.rcid == serverRun.rcid)) {
              localMatch = localRun;
              break;
            }
          }

          if (localMatch != null) {
            serverRun.rid = localMatch.rid;
          } else {
            serverRun.rid = 0; // New run from server
          }
          await LocalDataManager.shared.save(serverRun);
        }
      }
    }
  }

  static Future<void> saveRunData({required Run run}) async {
    String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
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
    String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
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
    String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
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
    String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
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
    String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
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
    String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
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
