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
  bool _isLoading = true;
  final GlobalKey _refreshIndicatorKey = GlobalKey();

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userData.isEmpty
          ? RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: getRequests,
              displacement: 40.0,
              edgeOffset: 0.0,
              color: Color(0xFF1976D2),
              backgroundColor: Colors.white,
              strokeWidth: 2.0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Requests Found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'There are no pending password reset requests',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _userData.length,
              itemBuilder: (context, index) {
                final user = _userData[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(
                          email: user['email'],
                          id: user['id'],
                        ),
                      ),
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
            ),
    );
  }

  Future<void> getRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse(
        "https://prakrutitech.xyz/batch_project/get_forgot_requests.php",
      );
      var response = await http.get(url);

      if (response.statusCode != 200) {
        print("HTTP error: ${response.statusCode}");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final jsonData = jsonDecode(response.body);
      print("Json data ${jsonData['requests']}");

      setState(() {
        _userData = jsonData['requests'] ?? [];
        _isLoading = false;
      });
      print("user data $_userData");
    } catch (e) {
      print("Error fetching requests: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
