import 'package:exdata_collector/Models/Boat.dart';
import 'package:exdata_collector/Models/Run.dart';
import 'package:exdata_collector/Models/Race.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalSaver {
  static void saveRunData({
    required int boatID,
    required int scope,
    required int hit,
    required String scopeToo,
    required String directionTOO,
    required int rcid,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index=prefs.getInt("runNums");
    index ??= 0;
    index+=1;
    prefs.setInt('runNums', index);
    String s="$index;$boatID;$scope;$scopeToo;$hit;$directionTOO;0;$rcid";
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
  static void deleteData()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("raceNums", 0);
    prefs.setInt("boatNums", 0);
    prefs.setInt("runNums", 0);
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
    for(int i=1;i<=index;i++)
    {
      String? s=await prefs.getString('run$i');
      print("-------------$s");
      var r=Run.fromString(s.toString());
      runs.add(r);
    }
    return runs;

  }
  static void updateRacesData({required List<Race> race}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("raceNums", race.length);
    for (int i = 0; i < race.length; i++)
    {
      int index=i+1;
      prefs.setString('race$index', jsonEncode(race[i].toJson()));
    }
  }
  static void updateBoatsData({required List<Boat> boats})
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("boatNums", boats.length);
    for (int i = 0; i < boats.length; i++)
    {
      int index=i+1;
      String? name=boats[i].name;
      String? boatClass=boats[i].boatClass;
      int dbID = boats[i].dbID;
      prefs.setString('boat$index', '$name;$boatClass;$dbID');
    }
  }
  static void updateRunsData({required List<Run> runs})
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("runNums", runs.length);
    for (int i = 0; i < runs.length; i++)
    {
      int index=i+1;
      int rid=runs[i].rid;
      int drid=runs[i].drid;
      int boatID=runs[i].boatID;
      int scopeToo=runs[i].scopeTo;
      String? directionToo=runs[i].directionTo;
      String? directionHit=runs[i].directionHit;
      int hit=runs[i].hit;
      int rcid=runs[i].rcid;

      String s="$index;$boatID;$scopeToo;$directionToo;$hit;$directionHit;$drid;$rcid";
      prefs.setString('run$index',s );
    }
  }
  static void saveBoatData({
    required String text,
    required String selectedOption,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index=prefs.getInt("boatNums");
    index ??= 0;
    index+=1;
    prefs.setInt("boatNums", index);
    prefs.setString('boat$index', '$text;$selectedOption;0');
  }
  static Future<List<Race>> loadAllRaces() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index=prefs.getInt("raceNums");
    List<Race> races=[];
    if(index ==null)
    {
      return [];
    }
    for(int i=1;i<=index;i++)
    {
      races.add(await loadRaceData(i));
    }
    return races;
  }
  static Future<Race> loadRaceData(int index) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loadedString=prefs.getString("race$index").toString();
    Race race =Race.fromJson(jsonDecode(loadedString));
    return race;
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
    //prefs.setInt("boatNums", 0);
    int? index=prefs.getInt("boatNums");
    List<Boat> boats=[];
    if(index ==null)
      {
        return [];
      }
    for(int i=1;i<=index;i++)
      {
          boats.add(await loadBoatData(i));
      }
    return boats;
  }
  static void saveRaceData({
    required Race race,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index=prefs.getInt("raceNums");
    index ??= 0;
    index+=1;
    prefs.setInt("raceNums", index);
    race.rcid=index;
    race.drcid=0;
    prefs.setString('race$index', jsonEncode(race.toJson()));
  }


}
