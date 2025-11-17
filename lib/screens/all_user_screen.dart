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
            if(snapshot.hasError){
              print("Snapshot has error ${snapshot.error}");
            }
           else if(!snapshot.hasData){
              print("Snapshot has no data");
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final roleColor = _getRoleColor(user['role']);

                return Card(
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

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue.shade600,
                              size: width < 400 ? 20 : 24,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserEditScreen(id: user['id'], user: user),
                                ),
                              );
                            },
                            tooltip: 'Edit User',
                          ),

                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade600,
                              size: width < 400 ? 20 : 24,
                            ),
                            onPressed: () => _deleteUser(user['id']),
                            tooltip: 'Delete User',
                          ),
                        ],
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

  void _deleteUser(int userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _users.removeWhere((user) => user['id'] == userId);
              });
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> getAllUser() async {
    var url = Uri.parse("https://prakrutitech.xyz/batch_project/view_user.php");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      print("Get project api working! ${response.body.toString()}");
      _users = jsonDecode(response.body);

      return _users;
    } else {
      print("Get user api not working!!");
    }
    throw Exception("Exception occurred!");
  }
}
