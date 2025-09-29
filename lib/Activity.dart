import "dart:convert";
class Activity {
  final String name;
  final List<String> muscles;
  final String equipment;
  final String difficulty;


  Activity({
    required this.name,
    required this.muscles,
    required this.equipment,
    required this.difficulty
  });

  factory Activity.fromJson(Map<String,dynamic> json){
    return Activity(name: json['name'], muscles: List<String>.from(json['muscles']), equipment: json['equipment'], difficulty: json['difficulty']);
    
  }
}

