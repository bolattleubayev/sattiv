class Entry {
  final String type;
  final String dateString;
  final int date;
  final int sgv;
  final String direction;
  final int noise;
  final int filtered;
  final int unfiltered;
  double get sgvMmolL {
    return sgv / 18;
  }

  Entry({
    required this.type,
    required this.dateString,
    required this.date,
    required this.sgv,
    required this.direction,
    required this.noise,
    required this.filtered,
    required this.unfiltered,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'type': type,
      'dateString': dateString,
      'sgv': sgv,
      'direction': direction,
      'noise': noise,
      'filtered': filtered,
      'unfiltered': unfiltered,
    };
  }

  Entry.defaultValues()
      : date = 0,
        type = "empty",
        dateString = "",
        sgv = 0,
        direction = "",
        noise = 0,
        filtered = 0,
        unfiltered = 0;

  Entry.fromMap(Map<String, dynamic> res)
      : date = res["date"],
        type = res["type"],
        dateString = res["dateString"],
        sgv = res["sgv"],
        direction = res["direction"],
        noise = res["noise"],
        filtered = res["filtered"],
        unfiltered = res["unfiltered"];

  @override
  String toString() {
    return 'Entry{date: $date, type: $type, dateString: $dateString, sgv: $sgv, direction: $direction, noise: $noise, filtered: $filtered, unfiltered: $unfiltered}';
  }
}
