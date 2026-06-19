import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Service to handle JWT authentication and session management.
class AuthService {
  // Replace with your server's backend URL
  static const String _baseUrl = 'http://161.97.103.48:5000';

  // Keys for storing tokens
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  /// Login with email and password
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _saveTokens(data);
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  /// Register a new parent account
  static Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _saveTokens(data);
      return data;
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  /// Refresh the access token
  static Future<bool> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'refresh_token': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveTokens(data);
      return true;
    } else {
      await clearSession();
      return false;
    }
  }

  /// Get the current access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Get the refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Get the user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout and clear session
  static Future<void> logout() async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken != null) {
        await http.post(
          Uri.parse('$_baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );
      }
    } catch (e) {
      // Ignore network errors during logout
    } finally {
      await clearSession();
    }
  }

  /// Clear all stored session data
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
  }

  /// Save tokens to secure storage
  static Future<void> _saveTokens(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data['access_token'] != null) {
      await prefs.setString(_accessTokenKey, data['access_token']);
    }
    if (data['refresh_token'] != null) {
      await prefs.setString(_refreshTokenKey, data['refresh_token']);
    }
    if (data['user_id'] != null) {
      await prefs.setString(_userIdKey, data['user_id'].toString());
    }
  }

  /// Get authorization header with current token
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAccessToken();
    if (token != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    }
    return {'Content-Type': 'application/json'};
  }
}