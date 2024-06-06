import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Models/Run.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSaver {
  static void saveRunData({
    required int boatID,
    required int scope,
    required int hit,
    required String scopeToo,
    required String directionTOO,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index=prefs.getInt("runNums");
    index ??= -1;
    index+=1;
    prefs.setInt('runNums', index);
    String s="$index;$boatID;$scope;$scopeToo;$hit;$directionTOO";
    prefs.setString('run$index',s );
  }
  static Future<List<Run>> loadRunData({required int id})
  async
  {
    List<Run> filtered=[];
    List<Run> all=await loadAllRunData();
    for (var run in all) { if(run.boatID==id){filtered.add(run);};}
    return filtered;
  }
  static Future<List<Run>> loadAllRunData()
  async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index=prefs.getInt("runNums");
    List<Run> runs=[];
    if(index ==null)
    {
      return [];
    }
    for(int i=0;i<index;i++)
    {
      String? s=await prefs.getString('run$i');
      var r=Run.fromString(s.toString());
      runs.add(r);
    }
    return runs;

  }

  static void saveBoatData({
    required String text,
    required String selectedOption,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index=prefs.getInt("boatNums");
    index ??= -1;
    index+=1;
    prefs.setInt("boatNums", index);
    prefs.setString('boat$index', '$text;$selectedOption');
  }
  static Future<Boat> loadBoatData(int index) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loadedString=prefs.getString("boat$index").toString();
    Boat b=new Boat();
    b.fromString(index,loadedString);
    return b;
  }
  static Future<List<Boat>> loadAllBoats() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index=prefs.getInt("boatNums");
    List<Boat> boats=[];
    if(index ==null)
      {
        return [];
      }
    for(int i=0;i<index;i++)
      {
          boats.add(await loadBoatData(i));
      }
    return boats;
  }
}
