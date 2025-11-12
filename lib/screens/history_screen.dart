// lib/screens/history_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/project.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: FutureBuilder(
        future: getProjects(),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasError){
            print("Error Api not found!");
          }
          else if(snapshot.hasData){
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final Project item = snapshot.data[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.history, color: Colors.blue),
                    title: Text(item.title),
                    subtitle: Text('${item.endDate.toLocal().toString().split(' ')[0]} by ${item.members.join(", ")}'),
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<List<Project>> getProjects() async {
    var url = Uri.parse(
      "https://prakrutitech.xyz/batch_project/view_project.php",
    );
    var response = await http.get(url);

    if (response.statusCode == 200) {
      print("Get project api working in history screeen!! ${response.body.toString()}");
      final jsonResponse = jsonDecode(response.body);

      final List<dynamic> projectsJson = jsonResponse['projects'] ?? [];

      // Convert to list of Project objects
      final List<Project> projects = projectsJson
          .map((json) => Project.fromJson(json))
          .toList();

      return projects;
    } else {
      print("Get project api not working!!");
      return [];
    }
  }
}
