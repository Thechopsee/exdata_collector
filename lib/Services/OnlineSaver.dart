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

  static Future<bool> checkServerAvailability({BuildContext? context, String? overrideUrl}) async {
    try {
      String baseUrl = overrideUrl ?? await (await SettingsManager.getInstance()).getBackendUrl();
      if (baseUrl.isEmpty) return false;

      if (!baseUrl.startsWith('http://') && !baseUrl.startsWith('https://')) {
        baseUrl = 'http://' + baseUrl;
      }

      String path = "/Heath";
      if (baseUrl.endsWith('/')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      }

      final response = await http.get(Uri.parse(baseUrl + path)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        _showError(context, 'Server je nedostupný: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _showError(context, 'Server je nedostupný nebo adresa je neplatná');
      return false;
    }
  }

  static Future<void> SynchronizeRaces({BuildContext? context, bool checkAvailability = true}) async {
    try {
      if (checkAvailability && !await checkServerAvailability(context: context)) return;
      List<Race> races = await LocalDataManager.shared.loadAll<Race>(Race);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'raceList': races.map((race) => race.toJson()).toList()});
      String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
      final response = await http.post(Uri.parse(baseUrl + "/races/sync"), headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Races synchronized successfully');
        final List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty) {
          List<Race> updatedRaces = responseData.map((data) => Race.fromJson(data)).toList();
          print('Races synchronized with updates: $updatedRaces');

          for (var updatedRace in updatedRaces) {
            updatedRace.drcid = updatedRace.rcid;
            bool foundLocal = false;
            for (var localRace in races) {
              if (localRace.name == updatedRace.name &&
                  localRace.date.toIso8601String() == updatedRace.date.toIso8601String()) {
                updatedRace.rcid = localRace.rcid;
                foundLocal = true;
                break;
              }
            }
            if (!foundLocal) {
              updatedRace.rcid = 0;
            }
            await LocalDataManager.shared.save(updatedRace);
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
      if (!await checkServerAvailability(context: context)) return;
      String baseUrl = await (await SettingsManager.getInstance()).getBackendUrl();
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
            bool foundLocal = false;
            for (var localBoat in boats) {
              if (localBoat.name == updatedBoat.name && localBoat.boatClass == updatedBoat.boatClass) {
                updatedBoat.bID = localBoat.bID;
                foundLocal = true;
                break;
              }
            }
            if (!foundLocal) {
              updatedBoat.bID = 0;
            }
            await LocalDataManager.shared.save(updatedBoat);
          }
          finalBoats = await LocalDataManager.shared.loadAll<Boat>(Boat);
        }
        await SynchronizeRaces(context: context, checkAvailability: false);
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
        List<Run> updatedRunsFromServer = responseData.map((data) => Run.fromJson(data)).toList();
        print('Runs synchronized with updates: $updatedRunsFromServer');

        List<Run> localRuns = await LocalDataManager.shared.loadAll<Run>(Run);

        for (var updatedRun in updatedRunsFromServer) {
          bool foundLocal = false;
          for (var localRun in localRuns) {
            if (localRun.dateTime.toIso8601String() == updatedRun.dateTime.toIso8601String()) {
              updatedRun.rid = localRun.rid;
              updatedRun.boatID = localRun.boatID;
              updatedRun.rcid = localRun.rcid;
              foundLocal = true;
              break;
            }
          }

          if (!foundLocal) {
            updatedRun.rid = 0;
            // Map boatID and rcid from server IDs to local IDs
            for (var boat in currentBoats) {
              if (boat.dbID == updatedRun.boatID) {
                updatedRun.boatID = boat.bID;
                break;
              }
            }
            for (var race in races) {
              if (race.drcid == updatedRun.rcid) {
                updatedRun.rcid = race.rcid;
                break;
              }
            }
          }

          await LocalDataManager.shared.save(updatedRun);
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
