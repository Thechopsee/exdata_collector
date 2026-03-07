import 'dart:convert';
import 'package:exdata_collector/Services/LocalDatabaseService/BaseDataHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exdata_collector/Models/Race.dart';

class RaceDataHandler extends BaseDataHandler {
  @override
  bool canHandle(Type model) => model == Race;

  @override
  Future<void> save(Object model) async {
    final prefs = await SharedPreferences.getInstance();
    Race race = model as Race;

    int index;
    if (race.rcid > 0) {
      index = race.rcid;
    } else {
      int lastIndex = prefs.getInt("raceNums") ?? 0;
      index = lastIndex + 1;
      prefs.setInt("raceNums", index);
      race.rcid = index;
    }

    await prefs.setString('race$index', jsonEncode(race.toJson()));
  }

  @override
  Future<List<Object>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt("raceNums");
    if (index == null) return [];
    List<Object> races = [];
    for (int i = 1; i <= index; i++) {
      String? data = prefs.getString('race$i');
      if (data != null) {
        Race race = Race.fromJson(jsonDecode(data));
        races.add(race);
      }
    }
    return races;
  }

  @override
  Future<Object?> load(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('race$id');
    if (data != null) {
      Race race = Race.fromJson(jsonDecode(data));
      return race;
    }
    return null;
  }

  @override
  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt("raceNums");
    if (index != null) {
      for (int i = 1; i <= index; i++) {
        await prefs.remove('race$i');
      }
      await prefs.setInt("raceNums", 0);
    }
  }
}
