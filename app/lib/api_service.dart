import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

/// Service to interact with a secure backend API that connects to MySQL.
///
/// This is the RECOMMENDED approach for production mobile applications.
class ApiService {
  // Replace with your server's backend URL
  static const String _baseUrl = 'http://161.97.103.48:5000';

  /// Fetch list of items/users from the database via REST API
  static Future<List<Map<String, dynamic>>> fetchItems() async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/items'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => json as Map<String, dynamic>).toList();
    } else if (response.statusCode == 401) {
      // Token expired, try to refresh
      final refreshed = await AuthService.refreshToken();
      if (refreshed) {
        return fetchItems(); // Retry with new token
      }
      throw Exception('Session expired. Please login again.');
    } else {
      throw Exception('Failed to load items from backend REST API');
    }
  }

  /// Insert a new item/user into the database via REST API
  static Future<void> insertItem(String title, String description) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/items'),
      headers: headers,
      body: jsonEncode({
        'title': title,
        'description': description,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create item via backend REST API');
    }
  }

  // ==================== Child Information ====================

  /// Submit child information form
  static Future<void> submitChildInfo({
    required String name,
    required String gender,
    required int age,
    required String birthDate,
    required String schoolGrade,
    required String wakeTime,
    required String sleepTime,
    required String likes,
    required String dislikes,
    required String fears,
    required String notes,
  }) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/api/child-info'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'gender': gender,
        'age': age,
        'birth_date': birthDate,
        'school_grade': schoolGrade,
        'wake_time': wakeTime,
        'sleep_time': sleepTime,
        'likes': likes,
        'dislikes': dislikes,
        'fears': fears,
        'notes': notes,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to submit child information: ${response.body}');
    }
  }

  /// Get child information
  static Future<Map<String, dynamic>?> getChildInfo() async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/api/child-info'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get child information');
    }
  }

  /// Update child information
  static Future<void> updateChildInfo({
    required int childId,
    required String name,
    required String gender,
    required int age,
    required String birthDate,
    required String schoolGrade,
    required String wakeTime,
    required String sleepTime,
    required String likes,
    required String dislikes,
    required String fears,
    required String notes,
  }) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.put(
      Uri.parse('$_baseUrl/api/child-info/$childId'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'gender': gender,
        'age': age,
        'birth_date': birthDate,
        'school_grade': schoolGrade,
        'wake_time': wakeTime,
        'sleep_time': sleepTime,
        'likes': likes,
        'dislikes': dislikes,
        'fears': fears,
        'notes': notes,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update child information');
    }
  }

  // ==================== Parent Information ====================

  /// Submit parent information form
  static Future<void> submitParentInfo({
    required String name,
    required String phone,
    required String relationship,
    required String jobTitle,
  }) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/api/parent-info'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'relationship': relationship,
        'job_title': jobTitle,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to submit parent information: ${response.body}');
    }
  }

  /// Get parent information
  static Future<Map<String, dynamic>?> getParentInfo() async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/api/parent-info'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get parent information');
    }
  }

  /// Update parent information
  static Future<void> updateParentInfo({
    required int parentId,
    required String name,
    required String phone,
    required String relationship,
    required String jobTitle,
  }) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.put(
      Uri.parse('$_baseUrl/api/parent-info/$parentId'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'relationship': relationship,
        'job_title': jobTitle,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update parent information');
    }
  }

  // ==================== Robot Settings ====================

  /// Submit robot settings
  static Future<void> submitRobotSettings({
    required String robotName,
    required String robotId,
    required String voiceType,
    required bool soundEnabled,
    required int volume,
  }) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/api/robot-settings'),
      headers: headers,
      body: jsonEncode({
        'robot_name': robotName,
        'robot_id': robotId,
        'voice_type': voiceType,
        'sound_enabled': soundEnabled,
        'volume': volume,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to submit robot settings: ${response.body}');
    }
  }

  /// Get robot settings
  static Future<Map<String, dynamic>?> getRobotSettings() async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/api/robot-settings'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get robot settings');
    }
  }

  // ==================== Alerts ====================

  /// Submit alerts settings
  static Future<void> submitAlerts({
    required bool sleepMonitoring,
    required bool activityAlerts,
    required String alertPhone,
  }) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/api/alerts'),
      headers: headers,
      body: jsonEncode({
        'sleep_monitoring': sleepMonitoring,
        'activity_alerts': activityAlerts,
        'alert_phone': alertPhone,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to submit alerts settings: ${response.body}');
    }
  }

  /// Get alerts settings
  static Future<Map<String, dynamic>?> getAlerts() async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/api/alerts'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get alerts settings');
    }
  }
}