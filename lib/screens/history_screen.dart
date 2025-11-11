// lib/screens/history_screen.dart
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo history data
    final List<Map<String, String>> _history = [
      {'date': '2025-11-01', 'action': 'Project Alpha approved', 'user': 'Admin'},
      {'date': '2025-10-30', 'action': 'User added', 'user': 'Admin'},
      // Add more...
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: Text(item['action']!),
              subtitle: Text('${item['date']} by ${item['user']}'),
            ),
          );
        },
      ),
    );
  }
}
