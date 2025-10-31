import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {
  static const String baseUrl = "http://localhost:5000";

  static Future<List<dynamic>> getCourses() async {
    final response = await http.get(Uri.parse("$baseUrl/courses"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Ошибка при получении курсов");
    }
  }
}
