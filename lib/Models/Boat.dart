import 'package:exdata_collector/Models/AbstractModel.dart';

class Boat implements AbstractModel{
  int bID = 0;
  int dbID = 0;
  String? name;
  String? boatClass;
  String? timerSeconds;
  String? timerExplanation;

  Boat({
    required this.name,
    required this.boatClass,
  });
  Boat.fromString(int id, String loadedString){
    List<String> ad = loadedString.split(';');
    bID = id;
    name = ad[0];
    boatClass = ad[1];
    if(ad.length>2) {
      dbID = int.parse(ad[2]);
    }
    if(ad.length==5) {
      timerSeconds = ad[3];
      timerExplanation = ad[4];
    }
  }

  Boat.fromJson(Map<String, dynamic> json)
      : bID = json['bID'],
        name = json['name'],
        boatClass = json['boatClass'],
        timerSeconds = json['timerSeconds'],
        timerExplanation = json['timerExplanation'];

  @override
  Map<String, dynamic> toJson() => {
    'id': bID,
    'dbID':dbID,
    'name': name,
    'boatClass': boatClass,
    'timerSeconds': timerSeconds,
    'timerExplanation': timerExplanation,
  };

  String toColumnString() {
    if(dbID!=0)
      {
        return "$dbID $name";
      }
    else
      {
        return "$bID $name";
      }

  }
}
