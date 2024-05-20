class Themes {
  final int id;
  final String title;
  final String description;
  final int price;
  final int difficulty;
  final int time;
  final int fear;
  final List<String> timetable;

  Themes({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.difficulty,
    required this.time,
    required this.fear,
    required this.timetable,
  });

  factory Themes.fromJson(Map<String, dynamic> json) {
    return Themes(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      difficulty: json['difficulty'] as int,
      time: json['time'] as int,
      fear: json['fear'] as int,
      timetable: (json['timetable'] as List<dynamic>)
          .map((dynamic time) => time as String)
          .toList(),
    );
  }
}
