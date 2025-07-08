import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = '5c71c940-50fb-49ec-85c6-c87e70792a79';
  static const String _baseUrl = 'http://analytics.eventregistry.org/api/v1/annotate';

  static Future<List<String>> fetchAnnotations(String text) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'text': text,
        'apiKey': _apiKey,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Assuming the response contains an 'annotations' field
      if (data['annotations'] != null) {
        return (data['annotations'] as List)
            .map((item) => item['spot'] as String)
            .toList();
      } else {
        throw Exception('No annotations found');
      }
    } else {
      throw Exception('Failed to load annotations');
    }
  }
}
