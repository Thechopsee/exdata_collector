import 'package:exdata_collector/Models/AbstractModel.dart';
import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Services/LocalDatabaseService/BaseDataHandler.dart';
import 'package:exdata_collector/Services/LocalDatabaseService/IDataHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoatDataHandler extends BaseDataHandler {
  @override
  bool canHandle(Type model) {
    bool test=model == Boat;
    return test;
  }

  @override
  Future<void> save(Object model) async {
    final prefs = await SharedPreferences.getInstance();
    Boat boat = model as Boat;
    int? index = prefs.getInt("boatNums") ?? 0;
    index++;
    prefs.setInt("boatNums", index);
    prefs.setString('boat$index', '${boat.name};${boat.boatClass};${boat.dbID}');
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
  Future<Object?> load(int id) async{
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('boat$id');
    if (data != null) {
      Boat boat = Boat.fromString(id, data);
      //boat.fromString(id, data);
      return boat;
    }
    return null;
  }


}
