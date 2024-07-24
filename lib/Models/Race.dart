class Race {
  String name;
  DateTime date;
  int rcid;
  int drcid;

  Race({
    required this.name,
    required this.date,
    required this.rcid,
    required this.drcid,
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      name: json['name'],
      date: DateTime.parse(json['date']),
      rcid: json['rcid'],
      drcid: json['drcid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'rcid': rcid,
      'drcid': drcid,
    };
  }

  @override
  String toString() {
    return '{name: $name, date: $date, rcid: $rcid, drcid: $drcid}';
  }
}
