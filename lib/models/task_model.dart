class Task {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  final DateTime createdAt;

  Task({
    String? id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();
}