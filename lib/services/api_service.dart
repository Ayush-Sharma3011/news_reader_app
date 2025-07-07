import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class ApiService {
  static const String _apiKey = 'YOUR_API_KEY_HERE';
  static const String _baseUrl = 'https://newsapi.org/v2';

  static Future<List<NewsArticle>> fetchNews([String query = '']) async {
    final url = Uri.parse(
      query.isEmpty
          ? '$_baseUrl/top-headlines?country=in&apiKey=$_apiKey'
          : '$_baseUrl/everything?q=$query&apiKey=$_apiKey',
    );

    final response = await http.get(url);
    final body = json.decode(response.body);

    if (response.statusCode == 200 && body['status'] == 'ok') {
      return (body['articles'] as List)
          .map((json) => NewsArticle.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
