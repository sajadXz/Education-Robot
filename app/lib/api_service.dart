import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to interact with a secure backend API that connects to MySQL.
/// 
/// This is the RECOMMENDED approach for production mobile applications.
class ApiService {
  // Replace with your server's backend URL
  static const String _baseUrl = 'https://api.yourdomain.com/v1';

  /// Fetch list of items/users from the database via REST API
  static Future<List<Map<String, dynamic>>> fetchItems() async {
    final response = await http.get(Uri.parse('$_baseUrl/items'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => json as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load items from backend REST API');
    }
  }

  /// Insert a new item/user into the database via REST API
  static Future<void> insertItem(String title, String description) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/items'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create item via backend REST API');
    }
  }
}
