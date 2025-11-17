import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'user_edit_screen.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  late List<dynamic> _users = [];
  final List<int> _deletedIndexes = [];

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'designer':
        return Colors.blue;
      case 'web developer':
        return Colors.green;
      case 'app developer':
        return Colors.purple;
      case 'tester':
        return Colors.orange;
      case 'backend':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUser();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // RESPONSIVE VALUES
    double avatarSize = width < 400
        ? 42
        : width < 600
        ? 50
        : 60;
    double titleSize = width < 400
        ? 16
        : width < 600
        ? 18
        : 20;
    double subtitleSize = width < 400 ? 12 : 14;
    double cardPadding = width < 400 ? 12 : 16;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Users',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future: getAllUser(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              print("Snapshot has error ${snapshot.error}");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error loading users',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          getAllUser();
                        });
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              print("Snapshot has no data");
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                if (_deletedIndexes.contains(index)) {
                  return SizedBox.shrink();
                }

                final user = _users[index];
                final roleColor = _getRoleColor(user['role']);

                return Dismissible(
                  key: Key(user['id'].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  confirmDismiss: (direction) async {
                    return await _showDeleteConfirmation(user['name']);
                  },
                  onDismissed: (direction) {
                    _deleteUser(index, user['id']);
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: roleColor, width: 6),
                        ),
                      ),

                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserEditScreen(id: user['id'], user: user),
                            ),
                          );
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(cardPadding),

                          leading: Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              color: roleColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: roleColor, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                user['name'][0],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: roleColor,
                                  fontSize: avatarSize * 0.45,
                                ),
                              ),
                            ),
                          ),

                          title: Text(
                            user['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleSize,
                            ),
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: subtitleSize,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    user['phone_number'],
                                    style: TextStyle(
                                      fontSize: subtitleSize,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: roleColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: roleColor.withOpacity(0.5),
                                  ),
                                ),
                                child: Text(
                                  user['role'],
                                  style: TextStyle(
                                    color: roleColor,
                                    fontSize: subtitleSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(String userName) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _deleteUser(int index, var userId) {
    final deletedUser = _users[index];

    setState(() {
      _deletedIndexes.add(index);
    });

    // Show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User ${deletedUser['name']} deleted'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            // Undo the deletion
            setState(() {
              _deletedIndexes.remove(index);
            });
          },
        ),
      ),
    );

    Future.delayed(Duration(seconds: 4), () {
      if (_deletedIndexes.contains(index)) {
        setState(() {
          _users.removeAt(index);
          _deletedIndexes.remove(index);
        });

      }
    });
  }

  Future<List<dynamic>> getAllUser() async {
    try {
      var url = Uri.parse(
        "https://prakrutitech.xyz/batch_project/view_user.php",
      );
      var response = await http.get(url);

      if (response.statusCode == 200) {
        print("Get user api working! ${response.body.toString()}");
        final responseData = jsonDecode(response.body);

        if (responseData is List) {
          _users = responseData;
        } else {
          _users = [];
        }

        return _users;
      } else {
        print("Get user api not working!! Status code: ${response.statusCode}");
        throw Exception("Failed to load users");
      }
    } catch (e) {
      print("Error in getAllUser: $e");
      throw Exception("Failed to load users: $e");
    }
  }
}
