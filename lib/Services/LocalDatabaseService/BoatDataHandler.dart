import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Services/LocalDatabaseService/BaseDataHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoatDataHandler extends BaseDataHandler {
  @override
  bool canHandle(Type model) {
    return model == Boat;
  }

  @override
  Future<void> save(Object model) async {
    final prefs = await SharedPreferences.getInstance();
    Boat boat = model as Boat;

    int index;
    if (boat.bID > 0) {
      index = boat.bID;
      int lastIndex = prefs.getInt("boatNums") ?? 0;
      if (index > lastIndex) {
        prefs.setInt("boatNums", index);
      }
    } else {
      int lastIndex = prefs.getInt("boatNums") ?? 0;
      index = lastIndex + 1;
      prefs.setInt("boatNums", index);
      boat.bID = index;
    }

    String data = '${boat.name};${boat.boatClass};${boat.dbID};${boat.timerSeconds ?? ""};${boat.timerExplanation ?? ""}';
    await prefs.setString('boat$index', data);
  }

  @override
  Future<List<Object>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt("boatNums");
    if (index == null) return [];
    List<Object> boats = [];
    for (int i = 1; i <= index; i++) {
      String? data = prefs.getString('boat$i');
      if (data != null) {
        Boat boat = Boat.fromString(i, data);
        boats.add(boat);
      }
    }
    return boats;
  }

  @override
  Future<Object?> load(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('boat$id');
    if (data != null) {
      Boat boat = Boat.fromString(id, data);
      return boat;
    }
    return null;
  }

  @override
  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt("boatNums");
    if (index != null) {
      for (int i = 1; i <= index; i++) {
        await prefs.remove('boat$i');
      }
      await prefs.setInt("boatNums", 0);
    }
  }
}
