class Run {
  int rid = 0;
  int drid= 0;
  int boatID = 0;
  int scopeTo = 0;
  String? directionTo;
  String? intentedPartOfGate;
  int hit = 0;
  String? directionHit;
  int rcid=0;
  DateTime dateTime = DateTime.now();

  Run.fromString(String runString) {
    var splitData = runString.split(';');
    rid = int.parse(splitData[0]);
    boatID = int.parse(splitData[1]);
    scopeTo = int.parse(splitData[2]);
    directionTo = splitData[3];
    hit = int.parse(splitData[4]);
    directionHit = splitData[5];
    drid=int.parse(splitData[6]);
    rcid=int.parse(splitData[7]);
    intentedPartOfGate = splitData[8] ;
    dateTime = DateTime.parse(splitData[9]);
  }

  Run.fromJson(Map<String, dynamic> json)
      : rid = json['rid'],
        drid=json['rid'],
        boatID = json['boatID'],
        scopeTo = json['scopeToo'],
        directionTo = json['directionToo'],
        hit = json['hit'],
        directionHit = json['directionHit'],
        dateTime = DateTime.parse(json['dateTime']),
        intentedPartOfGate = json['intentedPartOfGate'],
        rcid=json["rcid"];



  Map<String, dynamic> toJson() => {
    'rid': rid,
    'drid':drid,
    'boatID': boatID,
    'scopeToo': scopeTo,
    'directionToo': directionTo,
    'hit': hit,
    'directionHit': directionHit,
    'dateTime': dateTime.toIso8601String(),
    'intentedPartOfGate': intentedPartOfGate,
    'rcid':rcid,
  };
}
