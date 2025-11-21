import 'package:flutter/material.dart';

import 'forgot_password_screen.dart';

class ForgotRequestScreen extends StatefulWidget {
  const ForgotRequestScreen({super.key});

  @override
  State<ForgotRequestScreen> createState() => _ForgotRequestScreenState();
}

class _ForgotRequestScreenState extends State<ForgotRequestScreen> {

  final List<Map<String, String>> _userData = [
    {'email': 'designer@example.com', 'role': 'Designer'},
    {'email': 'developer@example.com', 'role': 'Developer'},
    {'email': 'webdev@example.com', 'role': 'Web Developer'},
    {'email': 'appdev@example.com', 'role': 'App Developer'},
    {'email': 'manager@example.com', 'role': 'Project Manager'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Forgot Password Request User"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding:  EdgeInsets.all(16.0),
        itemCount: _userData.length,
        itemBuilder: (context, index) {
          final user = _userData[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ForgotPasswordScreen(),
                ),
              );
            },
            child: Card(
              margin:EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading:Icon(Icons.person),
                title:Text(user['email']!),
                subtitle:Text(user['role']!),
                trailing:Icon(Icons.arrow_forward_ios),
              ),
            ),
          );
        },
      ),
    );
  }
}