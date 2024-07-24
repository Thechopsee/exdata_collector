class Run {
  int rid = 0;
  int drid= 0;
  int boatID = 0;
  int scopeTo = 0;
  String? directionTo;
  int hit = 0;
  String? directionHit;
  int rcid=0;

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
  }

  Run.fromJson(Map<String, dynamic> json)
      : rid = json['rid'],
        drid=json['rid'],
        boatID = json['boatID'],
        scopeTo = json['scopeToo'],
        directionTo = json['directionToo'],
        hit = json['hit'],
        directionHit = json['directionHit'],
        rcid=json["rcid"];

  Map<String, dynamic> toJson() => {
    'rid': rid,
    'drid':drid,
    'boatID': boatID,
    'scopeToo': scopeTo,
    'directionToo': directionTo,
    'hit': hit,
    'directionHit': directionHit,
    'rcid':rcid,
  };
}
