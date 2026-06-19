import 'package:mysql1/mysql1.dart';

/// Service to interact directly with a MySQL Database.
/// DEPRECATED: Use ApiService instead for REST API calls.
/// Kept for backward compatibility only.
class MySqlService {
  // Connection Configuration - Using REST API instead
  // Direct database connection from mobile app is NOT recommended for production
  static const String _host = '161.97.103.48';
  static const int _port = 3306;
  static const String _user = 'root';
  static const String _password = 'my_strong_root_password';
  static const String _dbName = 'robot_app_db';

  static final ConnectionSettings _settings = ConnectionSettings(
    host: _host,
    port: _port,
    user: _user,
    password: _password,
    db: _dbName,
  );

  /// Fetch list of items/users from the database
  /// DEPRECATED: Use ApiService.fetchItems() instead
  @Deprecated('Use ApiService.fetchItems() instead')
  static Future<List<Map<String, dynamic>>> fetchItems() async {
    final conn = await MySqlConnection.connect(_settings);
    try {
      final Results results = await conn.query('SELECT id, title, description FROM items');

      final List<Map<String, dynamic>> items = [];
      for (var row in results) {
        items.add({
          'id': row[0],
          'title': row[1],
          'description': row[2],
        });
      }
      return items;
    } catch (e) {
      throw Exception('Database Error: $e');
    } finally {
      await conn.close(); // Always close the connection
    }
  }

  /// Insert a new item/user into the database
  /// DEPRECATED: Use ApiService.insertItem() instead
  @Deprecated('Use ApiService.insertItem() instead')
  static Future<void> insertItem(String title, String description) async {
    final conn = await MySqlConnection.connect(_settings);
    try {
      await conn.query(
        'INSERT INTO items (title, description) VALUES (?, ?)',
        [title, description],
      );
    } catch (e) {
      throw Exception('Database Error: $e');
    } finally {
      await conn.close(); // Always close the connection
    }
  }
}
