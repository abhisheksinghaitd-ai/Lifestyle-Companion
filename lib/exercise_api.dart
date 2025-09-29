import 'dart:convert';
import 'package:http/http.dart' as http;
import 'exercise.dart';

class ExerciseApi {
  static const String baseUrl = "https://exercisedb.p.rapidapi.com";
  static const String apiKey = "b31e798d71mshd36679eafcd128ep139316jsn1ede1bb6541f"; // replace with your key
  static const String apiHost = "exercisedb.p.rapidapi.com";

  static Future<List<Exercise>> fetchExerciseByBodyPart(String bodyPart) async {
    final url = Uri.parse("$baseUrl/exercises/bodyPart/$bodyPart");

    final response = await http.get(
      url,
      headers: {
        "x-rapidapi-key": apiKey,
        "x-rapidapi-host": apiHost,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load exercises: ${response.statusCode} ${response.body}");
    }
  }
}
