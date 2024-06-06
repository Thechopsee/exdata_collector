import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Models/Run.dart';

class OnlineSaver {
  static const String baseUrl = 'http://yourapi.com';
  static Future<void> Synchronize() async
  {
    //check where is desynchronized
    
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
    final url = Uri.parse('$baseUrl/saveBoatData');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: boat.toJson(),
    );

    if (response.statusCode == 200) {
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
