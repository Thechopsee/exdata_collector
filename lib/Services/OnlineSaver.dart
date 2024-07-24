import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Models/Run.dart';
import 'package:exdata_collector/Models/Race.dart';

import 'package:exdata_collector/Services/LocalSaver.dart';

class OnlineSaver {
  static const String baseUrl = 'http://127.0.0.1:5000';
  static Future<void> SynchronizeRaces() async
  {
    List<Race> races=await LocalSaver.loadAllRaces();
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'raceList': races.map((race) => race.toJson()).toList()});

    final response = await http.post(Uri.parse(baseUrl+"/races/sync"), headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Races synchronized successfully');
      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isEmpty) {
        print('Races are synchronized, no changes.');
      }
      else
        {
          List<Race> updatedRaces = responseData.map((data) => Race.fromJson(data)).toList();
          print('Boats synchronized with updates: $updatedRaces');
          for (int i = 0; i < updatedRaces.length; i++)
          {
            updatedRaces[i].drcid=updatedRaces[i].rcid;
          }
          for(int i=0;i<races.length;i++)
          {
            for(int j=0;j<updatedRaces.length;j++) {
              if (races[i].name==updatedRaces[j].name && races[i].date==updatedRaces[j].date)
              {
                updatedRaces[j].rcid=races[i].rcid;
              }
            }
          }
          LocalSaver.updateRacesData(race:updatedRaces);
        }

    }
  }
  static Future<void> Synchronize() async
  {
    List<Boat> boats=await LocalSaver.loadAllBoats();
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'boatList': boats.map((boat) => boat.toJson()).toList()});

    final response = await http.post(Uri.parse(baseUrl+"/boats/sync"), headers: headers, body: body);

    if (response.statusCode == 200) {
    print('Boats synchronized successfully');
    final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isEmpty) {
      print('Boats are synchronized, no changes.');
      SynchronizeRaces();
      SynchronizeRun(boats);
      } else {
      List<Boat> updatedBoats = responseData.map((data) => Boat.fromJson(data)).toList();
      print('Boats synchronized with updates: $updatedBoats');
      for (int i = 0; i < updatedBoats.length; i++)
        {
          updatedBoats[i].dbID=updatedBoats[i].bID;
        }
      for(int i=0;i<boats.length;i++)
      {
        for(int j=0;j<updatedBoats.length;j++) {
          if (boats[i].boatClass==updatedBoats[j].boatClass && boats[i].name==updatedBoats[j].name)
            {
              updatedBoats[j].bID=boats[i].bID;
            }
        }
      }
        SynchronizeRaces();
        SynchronizeRun(updatedBoats);
        LocalSaver.updateBoatsData(boats:updatedBoats);

      }
    } else {
    print('Failed to synchronize boats: ${response.statusCode}');
  }
  }
  static Future<void> SynchronizeRun(List<Boat> boat) async
  {
    List<Run> runs= await LocalSaver.loadAllRunData();
    List<Race> races= await LocalSaver.loadAllRaces();
    List<Run> filteredRuns=[];
    for(int i=0;i<runs.length;i++)
      {
        bool f=false;
        for(int j=0;j<boat.length;j++) {
          if (runs[i].boatID == boat[j].bID) {
            runs[i].boatID=boat[j].dbID;
            f=true;
        }
      }
        for(int j=0;j<races.length;j++)
          {
            if (runs[i].rcid == races[j].rcid)
              {
                runs[i].rcid==races[j].drcid;
                f=true;
              }
          }
        if(f)
          {
            filteredRuns.add(runs[i]);
          }
      }

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'runList': filteredRuns.map((run) => run.toJson()).toList()});
    final response = await http.post(Uri.parse(baseUrl+"/runs/sync"), headers: headers, body: body);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<Run> updatedRuns = responseData.map((data) => Run.fromJson(data)).toList();
      print('Runs synchronized with updates: $updatedRuns');
      LocalSaver.updateRunsData(runs:updatedRuns);
    }

  }
  static Future<void> SynchronizeFromServer() async
  {
    //load data from server
    //save them local
  }
  static Future<void> SynchronizeToServer() async
  {
    //save unsync data to server
  }
  static Future<void> saveRunData({
    required Run run,
  }) async {
    final url = Uri.parse('$baseUrl/saveRunData');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: run.toJson(),
    );

    if (response.statusCode == 200) {
      print('Run data saved successfully');
    } else {
      print('Failed to save run data: ${response.statusCode}');
    }
  }

  // Načtení všech dat jízdy (Run) z serveru
  static Future<List<Run>> loadAllRunData() async {
    final url = Uri.parse('$baseUrl/loadAllRunData');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((run) => Run.fromJson(run)).toList();
    } else {
      print('Failed to load run data: ${response.statusCode}');
      return [];
    }
  }

  static Future<void> saveBoatData({
    required Boat boat,
  }) async {
    final url = Uri.parse('$baseUrl/boats');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:  json.encode(boat.toJson()),
    );

    if (response.statusCode == 201) {
      print('Boat data saved successfully');
    } else {
      print('Failed to save boat data: ${response.statusCode}');
    }
  }

  static Future<List<Boat>> loadAllBoats() async {
    final url = Uri.parse('$baseUrl/loadAllBoats');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((boat) => Boat.fromJson(boat)).toList();
    } else {
      print('Failed to load boats data: ${response.statusCode}');
      return [];
    }
  }
  static Future<void> saveRaceData({
    required Race race,
  }) async {
    final url = Uri.parse('$baseUrl/races');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(race.toJson()),
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
