import 'package:mysql1/mysql1.dart';

/// Service to interact directly with a MySQL Database.
/// 
/// Note: While useful for prototyping, direct connection to a database 
/// from a mobile app is not recommended for production due to security risks.
class MySqlService {
  // Connection Configuration
  static const String _host = 'your-database-host-or-ip'; // e.g., '10.0.2.2' for Local Android Emulator
  static const int _port = 3306;
  static const String _user = 'your_username';
  static const String _password = 'your_password';
  static const String _dbName = 'your_database_name';

  static final ConnectionSettings _settings = ConnectionSettings(
    host: _host,
    port: _port,
    user: _user,
    password: _password,
    db: _dbName,
  );

  /// Fetch list of items/users from the database
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
