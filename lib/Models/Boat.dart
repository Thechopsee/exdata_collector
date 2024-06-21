class Boat {
  int bID = 0;
  int dbID = 0;
  String? name;
  String? boatClass;
  Boat();
  void fromString(int id, String loadedString) {
    List<String> ad = loadedString.split(';');
    bID = id;
    name = ad[0];
    boatClass = ad[1];
    if(ad.length>2) {
      dbID = int.parse(ad[2]);
    }
  }

  Boat.fromJson(Map<String, dynamic> json)
      : bID = json['bID'],
        name = json['name'],
        boatClass = json['boatClass'];

  Map<String, dynamic> toJson() => {
    'id': bID,
    'dbID':dbID,
    'name': name,
    'boatClass': boatClass,
  };

  String toColumnString() {
    return "$bID $name";
  }
}
