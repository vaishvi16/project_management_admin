// lib/screens/add_project_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/project.dart';

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
  final _membersController = TextEditingController();
  String? _selectedType;
  List<String> _members = [];
  DateTime? _startDate;
  DateTime? _endDate;

  static const List<String> _types = ['Web', 'Mobile Application', 'Tester'];

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

                // Form Container
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
                          const SizedBox(height: 20),

                          // Project Type Dropdown
                          _buildTypeDropdown(),
                          const SizedBox(height: 20),

                          // Team Members Field
                          _buildTextField(
                            controller: _membersController,
                            label: 'Team Members (comma separated)',
                            icon: Icons.people_outline,
                            onChanged: (value) {
                              setState(() {
                                _members = value
                                    .split(',')
                                    .map((e) => e.trim())
                                    .where((e) => e.isNotEmpty)
                                    .toList();
                              });
                            },
                          ),

                          if (_members.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            _buildMembersChips(),
                          ],
                          const SizedBox(height: 20),

                          // Date Selection Section
                          _buildDateSelectionSection(),
                          const SizedBox(height: 30),

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

  Widget _buildMembersChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _members
          .map(
            (member) => Chip(
              label: Text(member, style: const TextStyle(fontSize: 12)),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                setState(() {
                  _members.remove(member);
                  _membersController.text = _members.join(', ');
                });
              },
            ),
          )
          .toList(),
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

      final newProject = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _clientController.text.toString(),
        title: _nameController.text,
        description: _descController.text,
        type: _selectedType ?? ' ',
        members: _members,
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
    _membersController.dispose();
    super.dispose();
  }

  Future<void> _insertProject(Project project ) async {
    var url = Uri.parse(
      "https://prakrutitech.xyz/batch_project/insert_project.php",
    );
   var response = await http.post(
      url,
      body: {
        "client_name": project.name,
        "title":project.title,
        "description": project.description,
        "type": project.type,
        "status": "Pending",
        "members_names": project.members.join(', '),
        "start_date": project.startDate.toIso8601String(),
        "end_date": project.endDate.toIso8601String(),
      },
    );

   if(response.statusCode == 200){
     print("everything is working!!!! ${response.body}");
   }
   else{
     print("not working");
   }

  }
}
