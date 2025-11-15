import 'package:flutter/material.dart';

import 'user_edit_screen.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  // Static user data
  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'Vaishvi',
      'mobileNo': '8585858585',
      'role': 'App Developer',
      'avatar': 'V',
    },
    {
      'id': 2,
      'name': 'Guarang',
      'mobileNo': '7979797979',
      'role': 'Web Developer',
      'avatar': 'G',
    },
    {
      'id': 3,
      'name': 'Dhaval',
      'mobileNo': '787878787878',
      'role': 'Designer',
      'avatar': 'D',
    },
    {
      'id': 4,
      'name': 'Virat Kohli',
      'mobileNo': '787878787878',
      'role': 'Tester',
      'avatar': 'V',
    },
    {
      'id': 5, // Fixed duplicate ID
      'name': 'Rohit Sharma',
      'mobileNo': '7575757575',
      'role': 'Developer',
      'avatar': 'R',
    },
  ];

  // Function to get color based on role - IMPROVED VERSION
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
        return Colors.amber;
      case 'developer':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Users',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: _users.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No Users Found',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
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
                    left: BorderSide(
                      color: roleColor,
                      width: 6,
                    ),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: roleColor,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        user['avatar'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: roleColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    user['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user['mobileNo'],
                            style: TextStyle(
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
                            fontSize: 12,
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
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>UserEditScreen()));
                        },
                        tooltip: 'Edit User',
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red.shade600,
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
        ),
      ),
    );
  }

  //Delete User Pop up
  void _deleteUser(int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _users.removeWhere((user) => user['id'] == userId);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('User deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}