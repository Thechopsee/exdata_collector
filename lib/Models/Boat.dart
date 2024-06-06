class Boat {
  int id = 0;
  String? name;
  String? boatClass;
  Boat();
  void fromString(int id, String loadedString) {
    List<String> ad = loadedString.split(';');
    this.id = id;
    name = ad[0];
    boatClass = ad[1];
  }

  Boat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        boatClass = json['boatClass'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'boatClass': boatClass,
  };

  // Metoda pro získání řetězce pro sloupec
  String toColumnString() {
    return "$id $name";
  }
}
