// lib/models/project.dart
class Project {
  final String id;
  final String name;
  final String title;
  final String description;
  final String type;
  final List<String> members;
  final List<String>? members_email;
  final DateTime startDate;
  final DateTime endDate;
  final double progress;
  final String status; // onhold, continue, pending, complete, approved

  Project({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.type,
    required this.members,
    this.members_email,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.status,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? '',
      name: json['client_name'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      members: (json['members_names'] != null)
          ? json['members_names'].toString().split(',').map((e) => e.trim()).toList()
          : [],
      members_email: (json['members_email'] != null)
          ? json['members_email'].toString().split(',').map((e) => e.trim()).toList()
          : [],
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      progress: 0.0,
    );
  }
}
