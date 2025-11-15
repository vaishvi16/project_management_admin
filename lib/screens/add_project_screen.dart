// lib/screens/add_project_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../models/project.dart';
import '../models/user_model.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _clientController = TextEditingController();
  String? _selectedType;
  String? _selectedDesigner;
  String? _selectedDeveloper;
  String? _selectedTester;
  String? _selectedBackend;
  DateTime? _startDate;
  DateTime? _endDate;

  // Lists to store users from API
  List<User> _allUsers = [];
  List<User> _designerUsers = [];
  List<User> _developerUsers = [];
  List<User> _testerUsers = [];
  List<User> _backendUsers = [];

  bool _isLoading = true;

  static const List<String> _types = ['Web', 'Mobile Application', 'Tester'];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var url = Uri.parse("https://prakrutitech.xyz/batch_project/view_user.php");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<User> users = data.map((user) => User.fromJson(user)).toList();

        setState(() {
          _allUsers = users;
          _designerUsers = users.where((user) => user.role.toLowerCase().contains('designer')).toList();
          _developerUsers = users.where((user) =>
          user.role.toLowerCase().contains('developer') ||
              user.role.toLowerCase().contains('app developer') ||
              user.role.toLowerCase().contains('web developer')
          ).toList();
          _testerUsers = users.where((user) => user.role.toLowerCase().contains('tester')).toList();
          _backendUsers = users.where((user) => user.role.toLowerCase().contains('backend')).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        _isLoading = false;
      });

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load users'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _getUserNameById(String? userId, List<User> userList) {
    if (userId == null) return '';
    final user = userList.firstWhere((user) => user.id == userId, orElse: () => User(id: '', name: '', email: '', role: '', phoneNumber: ''));
    return user.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Project',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_task,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Start New Project',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill in the project details to get started',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),

                if (_isLoading)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Client Name Field
                            _buildTextField(
                              controller: _clientController,
                              label: 'Client Name',
                              icon: Icons.business_center_outlined,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Please enter client name'
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            // Project Name Field
                            _buildTextField(
                              controller: _nameController,
                              label: 'Project Name',
                              icon: Icons.folder_outlined,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Please enter project name'
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            // Description Field
                            _buildTextField(
                              controller: _descController,
                              label: 'Project Description',
                              icon: Icons.description_outlined,
                              maxLines: 3,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Please enter project description'
                                  : null,
                            ),
                             SizedBox(height: 20),

                            // Project Type Dropdown
                            _buildTypeDropdown(),
                             SizedBox(height: 20),

                            _buildDesignerDropdown(),
                             SizedBox(height: 20),
                            _buildDeveloperDropdown(),
                             SizedBox(height: 20),

                            _buildTesterDropdown(),
                             SizedBox(height: 20),

                            // Backend Dropdown
                            _buildBackendDropdown(),
                             SizedBox(height: 20),

                            // Selected Team Members Display
                            _buildSelectedTeamMembers(),
                             SizedBox(height: 20),

                            // Date Selection Section
                            _buildDateSelectionSection(),
                             SizedBox(height: 30),

                            // Add Project Button
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _addProject,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text(
                                  'Create Project',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(icon, color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      decoration: InputDecoration(
        labelText: 'Project Type',
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.category_outlined, color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      items: _types
          .map(
            (type) => DropdownMenuItem(
          value: type,
          child: Text(
            type,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ),
      )
          .toList(),
      onChanged: (value) => setState(() => _selectedType = value),
      validator: (value) => value == null ? 'Please select project type' : null,
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildDesignerDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDesigner,
      decoration: InputDecoration(
        labelText: 'Designer User',
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.brush, color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      items: _designerUsers
          .map(
            (user) => DropdownMenuItem(
          value: user.id,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              // Text(
              //   user.role,
              //   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              // ),
            ],
          ),
        ),
      )
          .toList(),
      onChanged: (value) => setState(() => _selectedDesigner = value),
      validator: (value) => value == null ? 'Please select Designer' : null,
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildDeveloperDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDeveloper,
      decoration: InputDecoration(
        labelText: 'Developer User',
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.code, color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      items: _developerUsers
          .map(
            (user) => DropdownMenuItem(
          value: user.id,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              // Text(
              //   user.role,
              //   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              // ),
            ],
          ),
        ),
      )
          .toList(),
      onChanged: (value) => setState(() => _selectedDeveloper = value),
      validator: (value) => value == null ? 'Please select Developer' : null,
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildTesterDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTester,
      decoration: InputDecoration(
        labelText: 'Tester User',
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.bug_report, color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      items: _testerUsers
          .map(
            (user) => DropdownMenuItem(
          value: user.id,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              // Text(
              //   user.role,
              //   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              // ),
            ],
          ),
        ),
      )
          .toList(),
      onChanged: (value) => setState(() => _selectedTester = value),
      validator: (value) => value == null ? 'Please select Tester' : null,
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildBackendDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedBackend,
      decoration: InputDecoration(
        labelText: 'Backend User',
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.cloud, color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      items: _backendUsers
          .map(
            (user) => DropdownMenuItem(
          value: user.id,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              // Text(
              //   user.role,
              //   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              // ),
            ],
          ),
        ),
      )
          .toList(),
      onChanged: (value) => setState(() => _selectedBackend = value),
      validator: (value) => value == null ? 'Please select Backend User' : null,
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildSelectedTeamMembers() {
    List<String> selectedMembers = [];

    if (_selectedDesigner != null) {
      selectedMembers.add(_getUserNameById(_selectedDesigner, _designerUsers));
    }
    if (_selectedDeveloper != null) {
      selectedMembers.add(_getUserNameById(_selectedDeveloper, _developerUsers));
    }
    if (_selectedTester != null) {
      selectedMembers.add(_getUserNameById(_selectedTester, _testerUsers));
    }
    if (_selectedBackend != null) {
      selectedMembers.add(_getUserNameById(_selectedBackend, _backendUsers));
    }

    if (selectedMembers.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Team Members',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedMembers
              .map(
                (member) => Chip(
              label: Text(member, style: const TextStyle(fontSize: 12)),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDateSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Timeline',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDateButton(
                label: 'Start Date',
                date: _startDate,
                onPressed: () => _selectStartDate(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateButton(
                label: 'End Date',
                date: _endDate,
                onPressed: () => _selectEndDate(),
              ),
            ),
          ],
        ),
        if (_startDate != null && _endDate != null) ...[
          const SizedBox(height: 12),
          _buildDurationInfo(),
        ],
      ],
    );
  }

  Widget _buildDateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: date == null
              ? Colors.grey.shade600
              : Theme.of(context).primaryColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: date == null
                  ? Colors.grey.shade300
                  : Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: date == null
                  ? Colors.grey.shade500
                  : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                date == null ? label : DateFormat('MMM dd, yyyy').format(date),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: date == null
                      ? FontWeight.normal
                      : FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationInfo() {
    final duration = _endDate!.difference(_startDate!).inDays;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, size: 16, color: Colors.blue.shade600),
          const SizedBox(width: 8),
          Text(
            'Project Duration: $duration days',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _startDate = date);
      // Auto-set end date if not set
      if (_endDate == null || _endDate!.isBefore(date)) {
        setState(() => _endDate = date.add(const Duration(days: 30)));
      }
    }
  }

  Future<void> _selectEndDate() async {
    final initialDate =
        _startDate?.add(const Duration(days: 30)) ??
            DateTime.now().add(const Duration(days: 30));
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date != null) {
      setState(() => _endDate = date);
    }
  }

  void _addProject() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select project type'),
            backgroundColor: Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select both start and end dates'),
            backgroundColor: Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Collect all selected team members
      List<String> allMembers = [];

      if (_selectedDesigner != null) {
        allMembers.add(_getUserNameById(_selectedDesigner, _designerUsers));
      }
      if (_selectedDeveloper != null) {
        allMembers.add(_getUserNameById(_selectedDeveloper, _developerUsers));
      }
      if (_selectedTester != null) {
        allMembers.add(_getUserNameById(_selectedTester, _testerUsers));
      }
      if (_selectedBackend != null) {
        allMembers.add(_getUserNameById(_selectedBackend, _backendUsers));
      }

      final newProject = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _clientController.text.toString(),
        title: _nameController.text,
        description: _descController.text,
        type: _selectedType ?? ' ',
        members: allMembers,
        startDate: _startDate!,
        endDate: _endDate!,
        progress: 0.0,
        status: 'Pending',
      );

      _insertProject(newProject);

      // Simulate save and return
      Navigator.pop(context, newProject);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Project created successfully!'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _clientController.dispose();
    super.dispose();
  }

  Future<void> _insertProject(Project project) async {
    var url = Uri.parse(
      "https://prakrutitech.xyz/batch_project/insert_project.php",
    );
    var response = await http.post(
      url,
      body: {
        "client_name": project.name,
        "title": project.title,
        "description": project.description,
        "type": project.type,
        "status": "Pending",
        "members_names": project.members.join(', '), // This will include all selected users
        "start_date": project.startDate.toIso8601String(),
        "end_date": project.endDate.toIso8601String(),
      },
    );

    if (response.statusCode == 200) {
      print("Project inserted successfully! ${response.body}");
    } else {
      print("Failed to insert project: ${response.statusCode}");
    }
  }
}