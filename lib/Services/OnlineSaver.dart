import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Models/Run.dart';

import 'package:exdata_collector/Services/LocalSaver.dart';

class OnlineSaver {
  static const String baseUrl = 'http://127.0.0.1:5000';
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
      } else {
      List<Boat> updatedBoats = responseData.map((data) => Boat.fromJson(data)).toList();
      print('Boats synchronized with updates: $updatedBoats');
      for (int i = 0; i < updatedBoats.length; i++)
        {
          updatedBoats[i].dbID=updatedBoats[i].bID;
        }
      LocalSaver.updateBoatsData(boats:updatedBoats);
      }
    } else {
    print('Failed to synchronize boats: ${response.statusCode}');
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

  // Načtení všech dat lodí (Boat) z serveru
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
}
