import 'package:flutter/material.dart';
import 'mysql_service.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Education Robot MySQL Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DatabaseDemoHome(),
    );
  }
}

class DatabaseDemoHome extends StatefulWidget {
  const DatabaseDemoHome({super.key});

  @override
  State<DatabaseDemoHome> createState() => _DatabaseDemoHomeState();
}

class _DatabaseDemoHomeState extends State<DatabaseDemoHome> {
  bool _useDirectConnection = true; // Toggle between direct MySQL and REST API
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;
  String _statusMessage = 'Ready. Please configure your settings in service files.';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Fetching data...';
    });

    try {
      List<Map<String, dynamic>> data;
      if (_useDirectConnection) {
        data = await MySqlService.fetchItems();
      } else {
        data = await ApiService.fetchItems();
      }

      setState(() {
        _items = data;
        _statusMessage = 'Data loaded successfully! (${_items.length} items found)';
      });
    } catch (e) {
      setState(() {
        _items = [];
        _statusMessage = 'Error loading data. Make sure credentials/URLs are updated.\nDetails: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addData() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Adding item...';
    });

    try {
      if (_useDirectConnection) {
        await MySqlService.insertItem(title, desc);
      } else {
        await ApiService.insertItem(title, desc);
      }

      _titleController.clear();
      _descController.clear();
      setState(() {
        _statusMessage = 'Item added successfully!';
      });
      _fetchData(); // Refresh list after adding
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error adding item.\nDetails: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MySQL & API Integration Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Switch Connection Method
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text(
                      'Choose Connection Method',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('REST API (Secure)'),
                        Switch(
                          value: _useDirectConnection,
                          onChanged: (val) {
                            setState(() {
                              _useDirectConnection = val;
                              _items = [];
                              _statusMessage = 'Switched connection method. Load data to start.';
                            });
                          },
                        ),
                        const Text('Direct MySQL (Prototyping)'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _useDirectConnection
                          ? '⚠️ Direct Connection communicates with port 3306. Note: Not secure for production builds.'
                          : '✅ REST API makes secure HTTPS calls to a web server middleware. Best for production apps.',
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Form to Add Data
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Add New Item',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title / Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _addData,
                      icon: const Icon(Icons.add),
                      label: const Text('Insert to MySQL Database'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fetch and Status Controls
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _fetchData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Fetch Data'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: Text(
                'Status:\n$_statusMessage',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // List of retrieved items
            const Text(
              'Items in MySQL Database:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_items.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No items loaded. Update connection settings in mysql_service.dart or api_service.dart first, then click "Fetch Data".',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (ctx, index) {
                  final item = _items[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${item['id'] ?? index + 1}')),
                      title: Text(item['title'] ?? 'No Title'),
                      subtitle: Text(item['description'] ?? 'No Description'),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
