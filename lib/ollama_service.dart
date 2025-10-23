import 'dart:convert';
import 'package:http/http.dart' as http;

class OllamaService {
static const String baseUrl = 'https://unluminescent-deanna-refractometric.ngrok-free.dev/api/generate';



  static Future<String> askModel(String prompt) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': 'gemma3:4b', // your installed model name
        'prompt': prompt,
        'stream': false, // change to true if you want live token streaming
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'] ?? 'No response from model.';
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
