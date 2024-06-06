class Run {
  int id = 0;
  int boatID = 0;
  int scopeToo = 0;
  String? directionToo;
  int hit = 0;
  String? directionHit;

  Run.fromString(String runString) {
    var splitData = runString.split(';');
    id = int.parse(splitData[0]);
    boatID = int.parse(splitData[1]);
    scopeToo = int.parse(splitData[2]);
    directionToo = splitData[3];
    hit = int.parse(splitData[4]);
    directionHit = splitData[5];
  }

  Run.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        boatID = json['boatID'],
        scopeToo = json['scopeToo'],
        directionToo = json['directionToo'],
        hit = json['hit'],
        directionHit = json['directionHit'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'boatID': boatID,
    'scopeToo': scopeToo,
    'directionToo': directionToo,
    'hit': hit,
    'directionHit': directionHit,
  };
}
