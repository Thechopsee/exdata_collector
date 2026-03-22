import 'dart:convert';
import 'package:exdata_collector/Services/LocalDatabaseService/LocalDataManager.dart';
import 'package:exdata_collector/Services/SettingsManager.dart';
import 'package:http/http.dart' as http;
import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Models/Run.dart';
import 'package:exdata_collector/Models/Race.dart';
import 'package:flutter/material.dart';

class OnlineSaver {
  static void _showError(BuildContext? context, String message) {
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static void _showSuccess(BuildContext? context, String message) {
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  static Future<void> SynchronizeRaces({BuildContext? context}) async {
    try {
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
      } else {
        _showError(context, 'Chyba při synchronizaci závodů: ${response.statusCode}');
      }
    } catch (e) {
      _showError(context, 'Chyba při synchronizaci závodů: $e');
    }
  }

  static Future<void> Synchronize({BuildContext? context}) async {
    try {
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
        await SynchronizeRaces(context: context);
        await SynchronizeRun(finalBoats, context: context);
        _showSuccess(context, 'Synchronizace proběhla úspěšně');
      } else {
        _showError(context, 'Chyba při synchronizaci lodí: ${response.statusCode}');
      }
    } catch (e) {
      _showError(context, 'Chyba při synchronizaci: $e');
    }
  }

  static Future<void> SynchronizeRun(List<Boat> currentBoats, {BuildContext? context}) async {
    try {
      List<Run> runs = await LocalDataManager.shared.loadAll<Run>(Run);
      List<Race> races = await LocalDataManager.shared.loadAll<Race>(Race);
      List<Map<String, dynamic>> runsJson = [];

      for (var run in runs) {
        int? dbBoatID;
        for (var boat in currentBoats) {
          if (run.boatID == boat.bID) {
            dbBoatID = boat.dbID;
            break;
          }
        }

        int? dbRaceID;
        for (var race in races) {
          if (run.rcid == race.rcid) {
            dbRaceID = race.drcid;
            break;
          }
        }

        if (dbBoatID != null && dbRaceID != null) {
          var json = run.toJson();
          json['boatID'] = dbBoatID;
          json['rcid'] = dbRaceID;
          runsJson.add(json);
        }
      }

      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'runList': runsJson});
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
      } else {
        _showError(context, 'Chyba při synchronizaci jízd: ${response.statusCode}');
      }
    } catch (e) {
      _showError(context, 'Chyba při synchronizaci jízd: $e');
    }
  }

  static Future<void> saveRunData({required Run run, BuildContext? context}) async {
    try {
      String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
      final url = Uri.parse('$baseUrl/runs');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(run.toJson()),
      );

      if (response.statusCode == 201) {
        print('Run data saved successfully');
        _showSuccess(context, 'Jízda uložena online');
      } else {
        _showError(context, 'Chyba při ukládání jízdy: ${response.statusCode}');
      }
    } catch (e) {
      _showError(context, 'Chyba při ukládání jízdy: $e');
    }
  }

  static Future<List<Run>> loadAllRunData({BuildContext? context}) async {
    try {
      String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
      final url = Uri.parse('$baseUrl/runs');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((run) => Run.fromJson(run)).toList();
      } else {
        _showError(context, 'Chyba při načítání jízd: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _showError(context, 'Chyba při načítání jízd: $e');
      return [];
    }
  }

  static Future<void> saveBoatData({required Boat boat, BuildContext? context}) async {
    try {
      String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
      final url = Uri.parse('$baseUrl/boats');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(boat.toJson()),
      );

      if (response.statusCode == 201) {
        print('Boat data saved successfully');
        _showSuccess(context, 'Loď uložena online');
      } else {
        _showError(context, 'Chyba při ukládání lodi: ${response.statusCode}');
      }
    } catch (e) {
      _showError(context, 'Chyba při ukládání lodi: $e');
    }
  }

  static Future<List<Boat>> loadAllBoats({BuildContext? context}) async {
    try {
      String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
      final url = Uri.parse('$baseUrl/boats');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((boat) => Boat.fromJson(boat)).toList();
      } else {
        _showError(context, 'Chyba při načítání lodí: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _showError(context, 'Chyba při načítání lodí: $e');
      return [];
    }
  }

  static Future<void> saveRaceData({required Race race, BuildContext? context}) async {
    try {
      String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
      final url = Uri.parse('$baseUrl/races');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(race.toJson()),
      );

      if (response.statusCode == 201) {
        print('Race data saved successfully');
        _showSuccess(context, 'Závod uložen online');
      } else {
        _showError(context, 'Chyba při ukládání závodu: ${response.statusCode}');
      }
    } catch (e) {
      _showError(context, 'Chyba při ukládání závodu: $e');
    }
  }

  static Future<List<Race>> loadAllRaces({BuildContext? context}) async {
    try {
      String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
      final url = Uri.parse('$baseUrl/races');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((race) => Race.fromJson(race)).toList();
      } else {
        _showError(context, 'Chyba při načítání závodů: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _showError(context, 'Chyba při načítání závodů: $e');
      return [];
    }
  }
}
