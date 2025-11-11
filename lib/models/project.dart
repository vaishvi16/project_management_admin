// lib/models/project.dart
class Project {
  final String id;
  final String name;
  final String description;
  final String type;
  final List<String> members;
  final DateTime startDate;
  final DateTime endDate;
  final double progress;
  final String status; // onhold, continue, pending, complete, approved

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.members,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.status,
  });
}
