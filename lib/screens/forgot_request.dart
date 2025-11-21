import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_management_admin/models/request_model.dart';

import 'forgot_password_screen.dart';

class ForgotRequestScreen extends StatefulWidget {
  const ForgotRequestScreen({super.key});

  @override
  State<ForgotRequestScreen> createState() => _ForgotRequestScreenState();
}

class _ForgotRequestScreenState extends State<ForgotRequestScreen> {
  late List<dynamic> _userData = [];

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password Request"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(future: getRequests(), builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          print("Snapshot has error ${snapshot.error}");
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Error loading requests',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
          );
        }
        return  ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: _userData.length,
          itemBuilder: (context, index) {
            final user = _userData[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordScreen(email: user['email'], id: user['id'])),
                );
              },
              child: Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(user['email']!),
                  subtitle: Text(user['role']!),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            );
          },
        );
      },)
    );
  }

  Future<void> getRequests() async {
    var url = Uri.parse(
      "https://prakrutitech.xyz/batch_project/get_forgot_requests.php",
    );
    var response = await http.get(url);

    if (response.statusCode != 200) {
      print("HTTP error: ${response.statusCode}");
      return;
    }

    final jsonData = jsonDecode(response.body);
    print("Json data ${jsonData['requests']}");
    _userData = jsonData['requests'];
    print("user data $_userData");
  }
}
