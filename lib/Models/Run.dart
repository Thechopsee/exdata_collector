import 'package:exdata_collector/Models/AbstractModel.dart';

class Run implements AbstractModel {
  int rid = 0;
  int drid = 0;
  int boatID = 0;
  int scopeTo = 0;
  String? directionTo;
  String? intendedPartOfGate;
  int hit = 0;
  String? directionHit;
  int rcid = 0;
  DateTime dateTime = DateTime.now();

  Run();

  Run.fromString(String runString) {
    var splitData = runString.split(';');
    rid = int.tryParse(splitData[0]) ?? 0;
    boatID = int.tryParse(splitData[1]) ?? 0;
    scopeTo = int.tryParse(splitData[2]) ?? 0;
    directionTo = splitData[3];
    hit = int.tryParse(splitData[4]) ?? 0;
    directionHit = splitData[5];
    drid = int.tryParse(splitData[6]) ?? 0;
    rcid = int.tryParse(splitData[7]) ?? 0;
    if (splitData.length > 8) {
      intendedPartOfGate = splitData[8];
    }
    if (splitData.length > 9) {
      dateTime = DateTime.tryParse(splitData[9]) ?? DateTime.now();
    } else {
      dateTime = DateTime.now();
    }
  }

  Run.fromJson(Map<String, dynamic> json)
      : rid = json['rid'] ?? 0,
        drid = json['drid'] ?? 0,
        boatID = json['boatID'] ?? 0,
        scopeTo = json['scopeTo'] ?? 0,
        directionTo = json['directionTo'],
        hit = json['hit'] ?? 0,
        directionHit = json['directionHit'],
        dateTime = json['dateTime'] != null ? DateTime.parse(json['dateTime']) : DateTime.now(),
        intendedPartOfGate = json['intendedPartOfGate'],
        rcid = json['rcid'] ?? 0;

  @override
  Map<String, dynamic> toJson() => {
        'rid': rid,
        'drid': drid,
        'boatID': boatID,
        'scopeTo': scopeTo,
        'directionTo': directionTo,
        'hit': hit,
        'directionHit': directionHit,
        'dateTime': dateTime.toIso8601String(),
        'intendedPartOfGate': intendedPartOfGate,
        'rcid': rcid,
      };
}
