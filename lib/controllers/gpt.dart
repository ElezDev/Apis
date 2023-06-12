import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String apiKey = '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';
  static const String apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';

  static Future<String> sendRequest(String query) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt': query,
        'max_tokens': 50,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final completions = data['choices'] as List<dynamic>;
      final completionText = completions.first['text'] as String;
      return completionText;
    } else {
      throw Exception('Failed to send request to OpenAI API');
    }
  }
}
