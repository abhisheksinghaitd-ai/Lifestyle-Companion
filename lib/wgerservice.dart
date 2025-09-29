import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lifestyle_companion/WorkoutExercise.dart';
import 'exercise.dart';

class WgerService {
  static const String _baseUrl = "https://wger.de/api/v2/exercise/";

  // Fetch exercises (limit = how many you want)
 // wgerservice.dart
static Future<List<WorkoutExercise>> fetchExercises({int limit = 5}) async {
  final url = Uri.parse("$_baseUrl?language=2&limit=$limit");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List results = data['results'];
    return results.map((e) => WorkoutExercise.fromWgerJson(e)).toList();
  } else {
    throw Exception("Failed to load exercises: ${response.statusCode}");
  }
}

}
