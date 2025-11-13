// lib/screens/project_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/project.dart';

class ProjectEditScreen extends StatefulWidget {
  final Project project;

  const ProjectEditScreen({super.key, required this.project});

  @override
  State<ProjectEditScreen> createState() => _ProjectEditScreenState();
}

class _ProjectEditScreenState extends State<ProjectEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _clientController = TextEditingController();
  final _membersController = TextEditingController();
  String? _selectedType;
  String? _selectedStatus;
  List<String> _members = [];
  DateTime? _startDate;
  DateTime? _endDate;
  double _progress = 0.0;

  static const List<String> _types = ['Web', 'Mobile Application', 'Tester'];
  static const List<String> _statuses = ['Pending', 'Continue', 'On Hold', 'Complete', 'Approved'];

  @override
  void initState() {
    super.initState();
    // Initialize form with project data
    _nameController.text = widget.project.title;
    _descController.text = widget.project.description;
    _clientController.text = widget.project.name;
    _selectedType = widget.project.type;
    _selectedStatus = widget.project.status;
    _members = List.from(widget.project.members);
    _membersController.text = _members.join(', ');
    _startDate = widget.project.startDate;
    _endDate = widget.project.endDate;
    _progress = widget.project.progress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Project',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateProject,
          ),
        ],
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
                    Icons.edit,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Edit Project Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Update the project information',
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

                          // Project Status Dropdown
                          _buildStatusDropdown(),
                          const SizedBox(height: 20),

                          // Progress Slider
                          _buildProgressSlider(),
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

                          // Update Project Button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _updateProject,
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
                                'Update Project',
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

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      decoration: InputDecoration(
        labelText: 'Project Status',
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.stairs_outlined, color: Colors.grey.shade500),
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
      items: _statuses
          .map(
            (status) => DropdownMenuItem(
          value: status,
          child: Text(
            status,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ),
      )
          .toList(),
      onChanged: (value) => setState(() => _selectedStatus = value),
      validator: (value) => value == null ? 'Please select project status' : null,
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildProgressSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress: ${(_progress * 100).toInt()}%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _progress,
          min: 0,
          max: 1,
          divisions: 10,
          onChanged: (value) => setState(() => _progress = value),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0%', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            Text('50%', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            Text('100%', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      ],
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
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _startDate = date);
    }
  }

  Future<void> _selectEndDate() async {
    final initialDate = _startDate?.add(const Duration(days: 30)) ?? DateTime.now().add(const Duration(days: 30));
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? initialDate,
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date != null) {
      setState(() => _endDate = date);
    }
  }

  void _updateProject() {
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

      if (_selectedStatus == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select project status'),
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

      final updatedProject = Project(
        id: widget.project.id,
        name: _clientController.text.toString(),
        title: _nameController.text,
        description: _descController.text,
        type: _selectedType ?? ' ',
        members: _members,
        startDate: _startDate!,
        endDate: _endDate!,
        progress: _progress,
        status: _selectedStatus ?? 'Pending',
      );

      // Here you would typically call your update API
      _updateProjectInDatabase(updatedProject);

      Navigator.pop(context, updatedProject);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Project updated successfully!'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Future<void> _updateProjectInDatabase(Project project) async {
    // Implement your update API call here
    print('Updating project: ${project.id}');
    // var url = Uri.parse("https://prakrutitech.xyz/batch_project/update_project.php");
    // var response = await http.post(
    //   url,
    //   body: {
    //     "id": project.id,
    //     "client_name": project.name,
    //     "title": project.title,
    //     "description": project.description,
    //     "type": project.type,
    //     "status": project.status,
    //     "progress": project.progress.toString(),
    //     "members_names": project.members.join(', '),
    //     "start_date": project.startDate.toIso8601String(),
    //     "end_date": project.endDate.toIso8601String(),
    //   },
    // );

    // if(response.statusCode == 200){
    //   print("Project updated successfully! ${response.body}");
    // } else {
    //   print("Failed to update project");
    // }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _clientController.dispose();
    _membersController.dispose();
    super.dispose();
  }
}