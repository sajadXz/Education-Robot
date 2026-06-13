# Education Robot

An educational Flutter application integrating direct database connectivity and secure API patterns.

## Database & MySQL Integration

This project is configured to demonstrate two different approaches to working with MySQL in a mobile application.

### Project Structure
* `app/lib/mysql_service.dart` - Handles **direct TCP connection** to a remote MySQL database using the `mysql1` package. Ideal for quick prototyping and testing.
* `app/lib/api_service.dart` - Handles **secure connections via intermediate REST APIs** using the `http` package. This is the recommended approach for production deployments to ensure MySQL credentials remain hidden.
* `app/lib/main.dart` - A comprehensive demo UI dashboard allowing live toggling between the direct MySQL connection and the REST API wrapper.

---

### Setup & Usage

#### Option A: Direct MySQL Connection (Prototyping Only)
1. Open `app/lib/mysql_service.dart`.
2. Locate the private variables for the configuration and replace them with your database credentials:
   ```dart
   static const String _host = 'YOUR_DB_HOST';      // Use '10.0.2.2' for Local Android Emulator
   static const int _port = 3306;
   static const String _user = 'YOUR_DB_USER';
   static const String _password = 'YOUR_DB_PASSWORD';
   static const String _dbName = 'YOUR_DB_NAME';
   ```
3. Make sure your database contains an `items` table, or adjust the query in `mysql_service.dart` to match your schema.

#### Option B: Secure REST API Backend (Production Grade)
1. Set up a middleware backend server (e.g., using Node.js, Express, Fastify, Python FastAPI, PHP, etc.) that executes the database queries and exposes them over HTTP.
2. Open `app/lib/api_service.dart` and update your backend API URL:
   ```dart
   static const String _baseUrl = 'https://api.yourdomain.com/v1';
   ```

---

### Running the Project

Navigate to the `app` directory, resolve the dependencies, and launch the application:

```bash
cd app
flutter pub get
flutter run
```
