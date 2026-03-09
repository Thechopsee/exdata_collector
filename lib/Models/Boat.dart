import 'package:exdata_collector/Models/AbstractModel.dart';

class Boat implements AbstractModel {
  int bID = 0;
  int dbID = 0;
  String? name;
  String? boatClass;
  String? timerSeconds;
  String? timerExplanation;
  String? image;

  Boat({
    this.name,
    this.boatClass,
  });

  Boat.fromString(int id, String loadedString) {
    List<String> ad = loadedString.split(';');
    bID = id;
    if (ad.isNotEmpty) name = ad[0];
    if (ad.length > 1) boatClass = ad[1];
    if (ad.length > 2) {
      dbID = int.tryParse(ad[2]) ?? 0;
    }
    if (ad.length > 3) {
      timerSeconds = ad[3] == "" || ad[3] == "null" ? null : ad[3];
    }
    if (ad.length > 4) {
      timerExplanation = ad[4] == "" || ad[4] == "null" ? null : ad[4];
    }
    if (ad.length > 5) {
      image = ad[5] == "" || ad[5] == "null" ? null : ad[5];
    }
  }

  Boat.fromJson(Map<String, dynamic> json)
      : bID = json['bID'] ?? 0,
        dbID = json['dbID'] ?? 0,
        name = json['name'],
        boatClass = json['boatClass'],
        timerSeconds = json['timerSeconds'],
        timerExplanation = json['timerExplanation'],
        image = json['image'];

  @override
  Map<String, dynamic> toJson() => {
        'bID': bID,
        'dbID': dbID,
        'name': name,
        'boatClass': boatClass,
        'timerSeconds': timerSeconds,
        'timerExplanation': timerExplanation,
        'image': image,
      };

  String toColumnString() {
    if (dbID != 0) {
      return "$dbID $name";
    } else {
      return "$bID $name";
    }
  }
}
