class WorkoutExercise {
  final int id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String target;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  final String gifUrl;

  WorkoutExercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.target,
    required this.secondaryMuscles,
    required this.instructions,
    required this.gifUrl,
  });

  factory WorkoutExercise.fromWgerJson(Map<String, dynamic> json) {
    String bodyPart = json['category_name'] ?? 'Unknown';

    List<dynamic> muscles = json['muscles'] ?? [];
    String target = muscles.isNotEmpty ? muscles.first.toString() : 'Unknown';
    List<String> secondary = muscles.length > 1
        ? muscles.sublist(1).map((e) => e.toString()).toList()
        : [];

    List<dynamic> eq = json['equipment'] ?? [];
    String equipment = eq.map((e) => e.toString()).join(", ");

    List<String> instructions = (json['description'] ?? '')
        .toString()
        .split(RegExp(r'\.|\n'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return WorkoutExercise(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      bodyPart: bodyPart,
      equipment: equipment,
      target: target,
      secondaryMuscles: secondary,
      instructions: instructions,
      gifUrl: '', // placeholder
    );
  }
}
