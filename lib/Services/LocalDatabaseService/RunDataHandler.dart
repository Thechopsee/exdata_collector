import 'package:exdata_collector/Services/LocalDatabaseService/BaseDataHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exdata_collector/Models/Run.dart';

class RunDataHandler extends BaseDataHandler {
  @override
  bool canHandle(Type model) => model == Run;

  @override
  Future<void> save(Object model) async {
    final prefs = await SharedPreferences.getInstance();
    Run run = model as Run;

    int index;
    if (run.rid > 0) {
      index = run.rid;
    } else {
      int lastIndex = prefs.getInt("runNums") ?? 0;
      index = lastIndex + 1;
      prefs.setInt("runNums", index);
      run.rid = index;
    }

    String data = "$index;${run.boatID};${run.scopeTo};${run.directionTo};"
        "${run.hit};${run.directionHit};${run.drid};${run.rcid};"
        "${run.intendedPartOfGate ?? ""};${run.dateTime.toIso8601String()}";

    await prefs.setString('run$index', data);
  }

  @override
  Future<List<Object>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt("runNums");
    if (index == null) return [];
    List<Object> runs = [];
    for (int i = 1; i <= index; i++) {
      String? data = prefs.getString('run$i');
      if (data != null) {
        Run run = Run.fromString(data);
        runs.add(run);
      }
    }
    return runs;
  }

  @override
  Future<Object?> load(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('run$id');
    if (data != null) {
      Run run = Run.fromString(data);
      return run;
    }
    return null;
  }

  @override
  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt("runNums");
    if (index != null) {
      for (int i = 1; i <= index; i++) {
        await prefs.remove('run$i');
      }
      await prefs.setInt("runNums", 0);
    }
  }
}
